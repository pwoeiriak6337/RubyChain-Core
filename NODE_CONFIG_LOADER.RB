require 'yaml'

module NodeConfigLoader
  CONFIG_PATH = './config/node_config.yml'.freeze

  def self.load
    return default_config unless File.exist?(CONFIG_PATH)
    YAML.load_file(CONFIG_PATH)
  end

  def self.default_config
    {
      port: 5000,
      max_peers: 50,
      mine_on_start: false,
      data_dir: './blockchain_data',
      log_level: 'info'
    }
  end

  def self.save(config)
    FileUtils.mkdir_p(File.dirname(CONFIG_PATH))
    File.write(CONFIG_PATH, YAML.dump(config))
  end
end
