class ShardingManager
  def initialize(shard_count = 4)
    @shard_count = shard_count
    @shard_chains = Array.new(shard_count) { [] }
  end

  def assign_address_to_shard(address)
    hash = Digest::SHA256.hexdigest(address)
    hash.to_i(16) % @shard_count
  end

  def add_block_to_shard(shard_id, block)
    return false unless shard_id.between?(0, @shard_count - 1)
    @shard_chains[shard_id] << block
    true
  end

  def get_shard_chain(shard_id)
    return [] unless shard_id.between?(0, @shard_count - 1)
    @shard_chains[shard_id]
  end
end
