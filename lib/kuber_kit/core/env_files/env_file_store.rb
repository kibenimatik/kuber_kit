class KuberKit::Core::EnvFiles::EnvFileStore
  NotFoundError = Class.new(KuberKit::NotFoundError)
  AlreadyAddedError = Class.new(KuberKit::Error)

  def add(env_file)
    @@env_files ||= {}

    if !env_file.is_a?(KuberKit::Core::EnvFiles::AbstractEnvFile)
      raise ArgumentError.new("should be an instance of KuberKit::Core::EnvFiles::AbstractEnvFile, got: #{env_file.inspect}")
    end

    unless @@env_files[env_file.name].nil?
      raise AlreadyAddedError, "env_file #{env_file.name} was already added"
    end

    @@env_files[env_file.name] = env_file
  end

  def get(env_file_name)
    env_file = get_from_configuration(env_file_name) || 
               get_global(env_file_name)

    env_file
  end

  def get_global(env_file_name)
    @@env_files ||= {}
    env_file = @@env_files[env_file_name]

    if env_file.nil?
      raise NotFoundError, "env_file '#{env_file_name}' not found"
    end
    
    env_file
  end

  def get_from_configuration(env_file_name)
    env_files = KuberKit.current_configuration.env_files
    env_files[env_file_name]
  end

  def reset!
    @@env_files = {}
  end
end