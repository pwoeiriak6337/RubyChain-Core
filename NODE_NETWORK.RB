require 'uri'
require 'net/http'

class NodeNetwork
  def initialize
    @nodes = Set.new
  end

  def register_node(address)
    parsed_url = URI(address)
    @nodes.add("#{parsed_url.host}:#{parsed_url.port}")
  end

  def get_nodes
    @nodes.to_a
  end

  def node_exists?(address)
    parsed_url = URI(address)
    @nodes.include?("#{parsed_url.host}:#{parsed_url.port}")
  end

  def broadcast_transaction(transaction)
    @nodes.each do |node|
      send_transaction_to_node(node, transaction)
    end
  end

  private

  def send_transaction_to_node(node, transaction)
    uri = URI("http://#{node}/transactions/new")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri)
    request.body = transaction.to_json
    request['Content-Type'] = 'application/json'
    http.request(request)
  rescue StandardError
    false
  end
end
