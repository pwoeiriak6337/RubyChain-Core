require_relative 'blockchain_core'
require_relative 'wallet_manager'
require_relative 'api_routes'
require_relative 'logger_system'

LoggerSystem.info('Blockchain node starting...')

# Initialize core components
blockchain = BlockchainCore.new
wallet = WalletManager.new

LoggerSystem.info("Node wallet address: #{wallet.address}")
LoggerSystem.info("Genesis block created: #{blockchain.chain.first}")
LoggerSystem.info('Blockchain node running successfully')
