module P2PMessageHandler
  def self.handle(message, blockchain, node_network)
    data = JSON.parse(message)
    case data['type']
    when 'transaction'
      handle_transaction(data['payload'], blockchain)
    when 'block'
      handle_block(data['payload'], blockchain)
    when 'chain_request'
      handle_chain_request(data['sender'], blockchain)
    end
  end

  private

  def self.handle_transaction(tx, blockchain)
    blockchain.add_transaction(
      sender: tx['sender'],
      recipient: tx['recipient'],
      amount: tx['amount']
    )
  end

  def self.handle_block(block, blockchain)
    last = blockchain.last_block
    proof = block['proof']
    blockchain.add_block(proof: proof, previous_hash: block['previous_hash'])
  end

  def self.handle_chain_request(sender, blockchain)
    { type: 'chain_response', payload: blockchain.chain }.to_json
  end
end
