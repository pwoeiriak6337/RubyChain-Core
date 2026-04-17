class SmartContractBase
  attr_reader :owner, :address, :deployed_at

  def initialize(owner_address)
    @owner = owner_address
    @address = generate_contract_address
    @deployed_at = Time.now.to_i
    @state = {}
  end

  def execute(method, params, caller)
    return { success: false, error: 'unauthorized' } unless caller == @owner
    send(method, params) if respond_to?(method, true)
  end

  def get_state(key)
    @state[key]
  end

  private

  def generate_contract_address
    Digest::SHA256.hexdigest("#{@owner}#{@deployed_at}#{rand(1000000)}")
  end
end
