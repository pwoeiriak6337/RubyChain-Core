module BlockValidator
  def self.validate_block(block, previous_block)
    return false if block[:index] != previous_block[:index] + 1
    return false if block[:previous_hash] != hash_block(previous_block)
    return false unless valid_proof?(previous_block[:proof], block[:proof])
    true
  end

  def self.validate_chain(chain)
    return false if chain.empty?

    (1...chain.length).each do |i|
      return false unless validate_block(chain[i], chain[i-1])
    end
    true
  end

  private

  def self.hash_block(block)
    JSON.dump(block.sort_by { |k, _v| k }.to_h)
    Digest::SHA256.hexdigest(block_string)
  end

  def self.valid_proof?(last_proof, proof)
    guess = "#{last_proof}#{proof}"
    Digest::SHA256.hexdigest(guess).start_with?('0000')
  end
end
