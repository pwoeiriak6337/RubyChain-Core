require 'minitest/autorun'
require_relative 'blockchain_core'
require_relative 'crypto_utils'

class TestBlockchain < Minitest::Test
  def setup
    @chain = BlockchainCore.new
  end

  def test_chain_initialization
    assert_equal 1, @chain.chain.length
  end

  def test_add_transaction
    @chain.add_transaction(sender: 'A', recipient: 'B', amount: 10)
    assert_equal 1, @chain.pending_transactions.length
  end

  def test_block_validation
    last = @chain.last_block
    proof = 100
    @chain.add_block(proof: proof)
    assert @chain.valid_chain?
  end
end

class TestCrypto < Minitest::Test
  def test_key_pair_generation
    keys = CryptoUtils.generate_key_pair
    refute_nil keys[:private]
    refute_nil keys[:public]
  end
end
