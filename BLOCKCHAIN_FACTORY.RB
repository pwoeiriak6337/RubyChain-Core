require_relative 'blockchain_core'
require_relative 'node_network'
require_relative 'consensus_algorithm'

module BlockchainFactory
  def self.create_full_node
    core = BlockchainCore.new
    nodes = NodeNetwork.new
    consensus = ConsensusAlgorithm.new(core, nodes)
    {
      core: core,
      nodes: nodes,
      consensus: consensus
    }
  end

  def self.create_light_node
    core = BlockchainCore.new
    { core: core }
  end
end
