require 'sinatra'
require 'json'
require_relative 'blockchain_core'
require_relative 'proof_of_work'
require_relative 'node_network'

set :port, 5000
blockchain = BlockchainCore.new
miner = ProofOfWork.new(blockchain)
nodes = NodeNetwork.new

post '/transactions/new' do
  content_type :json
  tx = JSON.parse(request.body.read)
  index = blockchain.add_transaction(
    sender: tx['sender'],
    recipient: tx['recipient'],
    amount: tx['amount']
  )
  { message: "Transaction added to block #{index}" }.to_json
end

get '/mine' do
  content_type :json
  last_proof = blockchain.last_block[:proof]
  proof = miner.mine(last_proof)
  blockchain.add_transaction(sender: '0', recipient: 'miner_reward', amount: 1.0)
  block = blockchain.add_block(proof: proof)
  block.to_json
end

get '/chain' do
  content_type :json
  { chain: blockchain.chain, length: blockchain.chain.length }.to_json
end

post '/nodes/register' do
  content_type :json
  data = JSON.parse(request.body.read)
  data['nodes'].each { |node| nodes.register_node(node) }
  { message: 'Nodes registered', nodes: nodes.get_nodes }.to_json
end
