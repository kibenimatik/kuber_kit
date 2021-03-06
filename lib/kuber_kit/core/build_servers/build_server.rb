class KuberKit::Core::BuildServers::BuildServer < KuberKit::Core::BuildServers::AbstractBuildServer
  def setup(host:, user:, port:)
    @host = host
    @user = user
    @port = port

    self
  end

  def host
    raise ArgumentError, "host is not set, please use #setup method" if @host.nil?
    @host
  end

  def user
    raise ArgumentError, "user is not set, please use #setup method" if @user.nil?
    @user
  end

  def port
    raise ArgumentError, "port is not set, please use #setup method" if @port.nil?
    @port
  end
end