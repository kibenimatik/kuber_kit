require 'cli/ui'

class Indocker::Actions::ImageCompiler
  include Indocker::Import[
    "infrastructure.infra_store",
    "core.image_store",
    "compiler.image_compiler",
    "compiler.image_dependency_resolver",
    "shell.local_shell",
    "configs",
    "ui"
  ]

  Contract ArrayOf[Symbol], Hash => Any
  def call(image_names, options)
    ::CLI::UI::StdoutRouter.enable

    ui.spin("Loading infrastructure") do |spinner|
      infra_store.add_registry(Indocker::Infrastructure::Registry.new(:default))
      spinner.update_title("Loaded infrastructure")
    end

    ui.spin("Loading image definitions") do |spinner|
      files = image_store.load_definitions(options[:images_path])
      spinner.update_title("Loaded #{files.count} image definitions")
    end

    build_id = generate_build_id

    compile_images_with_dependencies(image_names, build_id)
  end

  private
    def compile_images_with_dependencies(image_names, build_id)
      resolved_dependencies = []
      dependencies = image_dependency_resolver.get_next(image_names)
      while (dependencies - resolved_dependencies).any?
        compile_simultaneously(dependencies, build_id)
        resolved_dependencies += dependencies
        dependencies = image_dependency_resolver.get_next(image_names, resolved: resolved_dependencies)
      end

      compile_simultaneously(image_names - resolved_dependencies, build_id)
    end

    def compile_simultaneously(image_names, build_id)
      threads = image_names.map do |dependency_name|
        Thread.new do
          compile_image(dependency_name, build_id)
        end
      end
      threads.each(&:join)
    end

    def compile_image(image_name, build_id)
      compile_dir = generate_compile_dir(build_id: build_id)

      ui.spin("Compiling #{image_name.to_s.yellow}") do |spinner|
        image_compiler.compile(local_shell, image_name, compile_dir)
        spinner.update_title("Compiled #{image_name.to_s.green}")
      end
    end

    def generate_build_id
      Time.now.strftime("%H%M%S")
    end

    def generate_compile_dir(build_id:)
      File.join(configs.image_compile_dir, build_id)
    end
end