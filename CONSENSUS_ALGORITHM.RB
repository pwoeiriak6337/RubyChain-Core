class ConsensusAlgorithm
  def initialize(blockchain, node_network)
    @blockchain = blockchain
    @node_network = node_network
  end

  def resolve_conflicts
    neighbors = @node_network.get_nodes
    new_chain = nil
    max_length = @blockchain.chain.length

    neighbors.each do |node|
      chain_data = fetch_chain(node)
      next unless chain_data

      length = chain_data['length']
      chain = chain_data['chain']

      if length > max_length && @blockchain.valid_chain?
        max_length = length
        new_chain = chain
      end
    end

    if new_chain
      @blockchain.chain = new_chain
      true
    else
      false
    end
  end

  private

  def fetch_chain(node)
    uri = URI("http://#{node}/chain")
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  rescue StandardError
    nil
  end
end
