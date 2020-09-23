class Indocker::Core::ImageFactory
  DEFAULT_DOCKERFILE_NAME = "Dockerfile".freeze
  DEFAULT_BUILD_CONTEXT_DIR = "build_context".freeze

  CircularDependencyError = Class.new(StandardError)
  DockerfileNotFoundError = Class.new(StandardError)

  include Indocker::Import["tools.file_presence_checker"]

  def create(definition, all_definitions: {}, dependency_tree: [])
    image_attrs = definition.to_image_attrs

    dependent_images = create_dependent_images(
      image_attrs, 
      all_definitions: all_definitions,
      dependency_tree: dependency_tree,
    )

    dockerfile_path = image_attrs.dockerfile_path || File.join(image_attrs.dir, DEFAULT_DOCKERFILE_NAME)
    file_presence_checker.check_file!(dockerfile_path)

    if image_attrs.build_context_dir
      file_presence_checker.check_dir!(image_attrs.build_context_dir)
      build_context_dir = image_attrs.build_context_dir
    else 
      default_dir = File.join(image_attrs.dir, DEFAULT_BUILD_CONTEXT_DIR)
      build_context_dir = file_presence_checker.dir_exists?(default_dir) ? default_dir : nil
    end

    Indocker::Core::Image.new(
      name:                   image_attrs.name,
      dependent_images:       dependent_images,
      registry_name:          image_attrs.registry_name,
      dockerfile_path:        dockerfile_path,
      build_args:             image_attrs.build_args,
      build_context_dir:      build_context_dir,
      tag:                    image_attrs.tag,
      before_build_callback:  image_attrs.before_build_callback,
      after_build_callback:   image_attrs.after_build_callback
    )
  end

  def create_dependent_images(image_attrs, all_definitions:, dependency_tree:)
    if dependency_tree.include?(image_attrs.name)
      raise CircularDependencyError, "Circular dependency found while creating #{image_attrs.name}. Dependency tree: #{dependency_tree.inspect}"
    end

    dependent_images = image_attrs.dependent_images || []
    dependent_images.map do |dependency|
      create(
        all_definitions[dependency], 
        all_definitions: all_definitions,
        dependency_tree: dependency_tree + [image_attrs.name]
      )
    end
  end
end