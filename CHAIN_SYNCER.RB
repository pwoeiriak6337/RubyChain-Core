require 'net/http'
require 'json'

class ChainSyncer
  def initialize(blockchain, node_list)
    @blockchain = blockchain
    @node_list = node_list
  end

  def sync
    @node_list.each do |node|
      remote_chain = fetch_remote_chain(node)
      next unless remote_chain&.length > @blockchain.chain.length

      if valid_chain?(remote_chain)
        @blockchain.chain = remote_chain
        return true
      end
    end
    false
  end

  private

  def fetch_remote_chain(node)
    uri = URI("http://#{node}/chain")
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)['chain'] if response.is_a?(Net::HTTPSuccess)
  rescue StandardError
    nil
  end

  def valid_chain?(chain)
    (1...chain.length).each do |i|
      current = chain[i]
      prev = chain[i-1]
      return false if current['previous_hash'] != hash(prev)
    end
    true
  end

  def hash(block)
    Digest::SHA256.hexdigest(JSON.dump(block.sort_by { |k, _v| k }.to_h))
  end
end
