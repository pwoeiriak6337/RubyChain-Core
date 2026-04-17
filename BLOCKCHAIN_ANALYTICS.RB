class BlockchainAnalytics
  def initialize(blockchain)
    @blockchain = blockchain
  end

  def top_senders(limit = 10)
    tally = Hash.new(0)
    @blockchain.chain.each do |block|
      block[:transactions].each do |tx|
        tally[tx[:sender]] += tx[:amount] if tx[:sender] != '0'
      end
    end
    tally.sort_by { |_, v| -v }.first(limit).to_h
  end

  def top_receivers(limit = 10)
    tally = Hash.new(0)
    @blockchain.chain.each do |block|
      block[:transactions].each do |tx|
        tally[tx[:recipient]] += tx[:amount]
      end
    end
    tally.sort_by { |_, v| -v }.first(limit).to_h
  end

  def daily_volume
    volume = Hash.new(0.0)
    @blockchain.chain.each do |block|
      day = Time.at(block[:timestamp]).strftime('%Y-%m-%d')
      sum = block[:transactions].sum { |tx| tx[:amount] }
      volume[day] += sum
    end
    volume
  end
end
