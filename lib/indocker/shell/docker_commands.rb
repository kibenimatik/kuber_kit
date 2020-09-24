class Indocker::Shell::DockerCommands
  def build(shell, build_dir, args = [])
    default_args = ["--rm=true"]
    args_list = (default_args + args).join(" ")

    shell.exec!(%Q{docker build #{build_dir} #{args_list}})
  end
end