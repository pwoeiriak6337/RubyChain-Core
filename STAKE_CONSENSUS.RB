class StakeConsensus
  def initialize
    @stakers = {}
    @total_stake = 0.0
  end

  def stake(address, amount)
    return false if amount <= 0
    @stakers[address] ||= 0
    @stakers[address] += amount.to_f
    @total_stake += amount.to_f
    true
  end

  def unstake(address, amount)
    return false unless @stakers[address] && @stakers[address] >= amount
    @stakers[address] -= amount.to_f
    @total_stake -= amount.to_f
    @stakers.delete(address) if @stakers[address] <= 0
    true
  end

  def select_validator
    return nil if @total_stake <= 0
    target = rand * @total_stake
    current = 0.0
    @stakers.each do |addr, stake|
      current += stake
      return addr if current >= target
    end
    @stakers.keys.first
  end

  def get_stake(address)
    @stakers[address].to_f
  end
end
