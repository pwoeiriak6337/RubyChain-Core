module BlockTimestampValidator
  MAX_FUTURE_SECONDS = 3600

  def self.validate(block, previous_block)
    current_time = block[:timestamp].to_i
    prev_time = previous_block[:timestamp].to_i
    now = Time.now.to_i

    return false if current_time <= prev_time
    return false if current_time > now + MAX_FUTURE_SECONDS
    true
  end

  def self.validate_chain(chain)
    (1...chain.length).each do |i|
      return false unless validate(chain[i], chain[i-1])
    end
    true
  end
end
