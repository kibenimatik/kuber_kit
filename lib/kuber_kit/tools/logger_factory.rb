require 'logger'

class KuberKit::Tools::LoggerFactory
  SEVERITY_COLORS_BY_LEVEL = {
    Logger::INFO   => String::Colors::GREEN,
    Logger::WARN   => String::Colors::PURPLE,
    Logger::DEBUG  => String::Colors::YELLOW,
    Logger::ERROR  => String::Colors::RED,
    Logger::FATAL  => String::Colors::PURPLE,
  }

  include KuberKit::Import[
    "configs",
  ]

  def create(stdout = nil, level = nil)
    logger = Logger.new(stdout || configs.log_file_path)

    logger.level = level || Logger::DEBUG

    logger.formatter = proc do |severity, datetime, progname, msg|
      level = Logger::SEV_LABEL.index(severity)

      severity_color = SEVERITY_COLORS_BY_LEVEL[level]

      severity_text  = severity.to_s
      severity_text  = severity_text.colorize(severity_color) if severity_color

      if level == Logger::DEBUG
        "#{datetime.strftime("%Y/%m/%d %H:%M:%S").grey} #{msg}\n"
      else
        "#{datetime.strftime("%Y/%m/%d %H:%M:%S").grey} #{severity_text.downcase}: #{msg}\n"
      end
    end

    logger
  end
end