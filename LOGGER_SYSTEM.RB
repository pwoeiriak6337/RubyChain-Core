require 'logger'

module LoggerSystem
  LOG_FILE = './logs/blockchain.log'.freeze

  def self.logger
    return @logger if @logger
    FileUtils.mkdir_p(File.dirname(LOG_FILE))
    @logger = Logger.new(LOG_FILE, 'daily')
    @logger.level = Logger::INFO
    @logger.formatter = ->(severity, timestamp, _, msg) {
      "[#{timestamp.strftime('%Y-%m-%d %H:%M:%S')}] #{severity}: #{msg}\n"
    }
    @logger
  end

  def self.info(message)
    logger.info(message)
  end

  def self.warn(message)
    logger.warn(message)
  end

  def self.error(message)
    logger.error(message)
  end
end
