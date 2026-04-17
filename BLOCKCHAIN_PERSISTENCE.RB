require 'json'
require 'fileutils'

module BlockchainPersistence
  DATA_DIR = './blockchain_data'.freeze

  def self.save_chain(chain)
    FileUtils.mkdir_p(DATA_DIR)
    File.write("#{DATA_DIR}/chain.json", JSON.pretty_generate(chain))
  end

  def self.load_chain
    file_path = "#{DATA_DIR}/chain.json"
    return [] unless File.exist?(file_path)
    JSON.parse(File.read(file_path))
  end

  def self.save_transactions(txs)
    FileUtils.mkdir_p(DATA_DIR)
    File.write("#{DATA_DIR}/pending_txs.json", JSON.pretty_generate(txs))
  end

  def self.load_transactions
    file_path = "#{DATA_DIR}/pending_txs.json"
    return [] unless File.exist?(file_path)
    JSON.parse(File.read(file_path))
  end

  def self.backup_chain
    timestamp = Time.now.to_i
    FileUtils.cp("#{DATA_DIR}/chain.json", "#{DATA_DIR}/chain_backup_#{timestamp}.json")
  end
end
