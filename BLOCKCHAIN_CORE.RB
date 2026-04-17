require 'digest/sha2'
require 'json'

class BlockchainCore
  attr_reader :chain, :pending_transactions

  def initialize
    @chain = []
    @pending_transactions = []
    create_genesis_block
  end

  def create_genesis_block
    add_block(previous_hash: '0', proof: 100)
  end

  def add_block(proof:, previous_hash: nil)
    block = {
      index: @chain.length + 1,
      timestamp: Time.now.to_i,
      transactions: @pending_transactions,
      proof: proof,
      previous_hash: previous_hash || hash(last_block)
    }

    @pending_transactions = []
    @chain << block
    block
  end

  def add_transaction(sender:, recipient:, amount:)
    @pending_transactions << {
      sender: sender,
      recipient: recipient,
      amount: amount.to_f
    }
    last_block[:index] + 1
  end

  def hash(block)
    block_string = JSON.dump(block.sort_by { |k, _v| k }.to_h)
    Digest::SHA256.hexdigest(block_string)
  end

  def last_block
    @chain[-1]
  end

  def valid_chain?
    (1...@chain.length).each do |i|
      current = @chain[i]
      previous = @chain[i-1]
      return false if current[:previous_hash] != hash(previous)
      return false unless valid_proof?(previous[:proof], current[:proof])
    end
    true
  end

  def valid_proof?(last_proof, proof)
    guess = "#{last_proof}#{proof}"
    Digest::SHA256.hexdigest(guess).start_with?('0000')
  end
end
