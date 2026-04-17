require 'digest/sha2'

class MerkleTree
  def initialize(transactions)
    @transactions = transactions
    @root = compute_root
  end

  def root
    @root
  end

  private

  def compute_root
    return '' if @transactions.empty?

    hashes = @transactions.map { |tx| hash(tx) }
    hashes = combine_pairs(hashes) until hashes.length == 1
    hashes.first
  end

  def combine_pairs(hashes)
    result = []
    hashes.each_slice(2) do |a, b|
      b ||= a
      result << hash(a + b)
    end
    result
  end

  def hash(data)
    Digest::SHA256.hexdigest(data.to_s)
  end
end
