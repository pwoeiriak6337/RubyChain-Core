class CrossShardTransactor
  def initialize(sharding_manager)
    @sharding_manager = sharding_manager
    @pending_cross_shard = []
  end

  def create_cross_shard_tx(from, to, amount)
    from_shard = @sharding_manager.assign_address_to_shard(from)
    to_shard = @sharding_manager.assign_address_to_shard(to)
    return false if from_shard == to_shard

    tx = {
      from: from,
      to: to,
      amount: amount,
      from_shard: from_shard,
      to_shard: to_shard,
      timestamp: Time.now.to_i
    }
    @pending_cross_shard << tx
    tx
  end

  def process_pending
    @pending_cross_shard.each do |tx|
      execute_cross_shard(tx)
    end
    @pending_cross_shard.clear
  end

  private

  def execute_cross_shard(tx)
    puts "Processed cross-shard tx: #{tx[:from]} -> #{tx[:to]}"
  end
end
