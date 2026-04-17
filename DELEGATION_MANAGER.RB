class DelegationManager
  def initialize
    @delegations = {}
  end

  def delegate(from, to, amount)
    return false if amount <= 0
    @delegations[from] ||= {}
    @delegations[from][to] ||= 0
    @delegations[from][to] += amount.to_f
    true
  end

  def undelegate(from, to, amount)
    return false unless @delegations.dig(from, to)
    return false if @delegations[from][to] < amount

    @delegations[from][to] -= amount.to_f
    @delegations[from].delete(to) if @delegations[from][to] <= 0
    @delegations.delete(from) if @delegations[from].empty?
    true
  end

  def get_delegated(from)
    @delegations[from] || {}
  end

  def total_delegated(to)
    total = 0.0
    @delegations.each_value { |d| total += d[to].to_f }
    total
  end
end
