require_relative 'blockchain_core'
require_relative 'merkle_tree'

class BlockGenerator
  def initialize(blockchain)
    @blockchain = blockchain
  end

  def generate_new_block(proof)
    last_block = @blockchain.last_block
    merkle_root = MerkleTree.new(@blockchain.pending_transactions).root

    block = {
      index: last_block[:index] + 1,
      timestamp: Time.now.to_i,
      transactions: @blockchain.pending_transactions,
      merkle_root: merkle_root,
      proof: proof,
      previous_hash: @blockchain.hash(last_block)
    }

    @blockchain.pending_transactions = []
    @blockchain.chain << block
    block
  end
end
