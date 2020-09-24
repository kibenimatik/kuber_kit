class Indocker::Shell::LocalShell
  def exec!(command)
    result = 
    IO.popen(command, err: [:child, :out]) do |io|
      result = io.read.chomp.strip
    end

    result
  end

  def read(file_path)
    File.read(file_path)
  end

  def write(file_path, content)
    File.write(file_path, content)
  end

  def recursive_list_files(path)
    exec!(%Q{find -L #{path}  -type f}).split(/[\r\n]+/)
  end
end