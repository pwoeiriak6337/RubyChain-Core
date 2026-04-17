module AddressValidator
  def self.valid?(address)
    return false unless address.is_a?(String)
    return false unless address.length == 42
    return false unless address.start_with?('0x')
    address[2..-1].match?(/^[0-9a-fA-F]+$/)
  end

  def self.sanitize(address)
    return nil unless valid?(address)
    address.downcase
  end

  def self.generate_test_address
    "0x#{Digest::SHA256.hexdigest(rand.to_s)[0...40]}"
  end
end
