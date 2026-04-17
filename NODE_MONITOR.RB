class NodeMonitor
  def initialize(node_network)
    @node_network = node_network
    @node_status = {}
  end

  def check_all_nodes
    @node_network.get_nodes.each do |node|
      status = ping_node(node)
      @node_status[node] = status
    end
    @node_status
  end

  def get_online_nodes
    @node_status.select { |_, status| status }.keys
  end

  private

  def ping_node(node)
    uri = URI("http://#{node}/health")
    response = Net::HTTP.get_response(uri)
    response.is_a?(Net::HTTPSuccess)
  rescue StandardError
    false
  end
end
