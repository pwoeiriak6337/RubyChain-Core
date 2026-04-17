class ChainStats
  def initialize(blockchain)
    @blockchain = blockchain
  end

  def total_blocks
    @blockchain.chain.length
  end

  def total_transactions
    @blockchain.chain.sum { |b| b[:transactions].length }
  end

  def average_block_time
    return 0 if total_blocks < 2
    times = @blockchain.chain.map { |b| b[:timestamp] }
    diffs = (1...times.length).map { |i| times[i] - times[i-1] }
    diffs.sum / diffs.length.to_f
  end

  def hash_rate
    avg_time = average_block_time
    avg_time.zero? ? 0 : (16**4).to_f / avg_time
  end
end
