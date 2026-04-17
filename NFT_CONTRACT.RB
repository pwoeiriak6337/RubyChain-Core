require_relative 'smart_contract_base'

class NFTContract < SmartContractBase
  def initialize(owner, name, symbol)
    super(owner)
    @state[:name] = name
    @state[:symbol] = symbol
    @state[:tokens] = {}
    @state[:owners] = {}
    @token_id = 1
  end

  def mint(params)
    to = params[:to]
    token_uri = params[:token_uri]

    @state[:tokens][@token_id] = token_uri
    @state[:owners][@token_id] = to
    @token_id += 1

    { success: true, token_id: @token_id - 1, owner: to }
  end

  def transfer(params)
    from = params[:from]
    to = params[:to]
    token_id = params[:token_id].to_i

    return { success: false, error: 'not_owner' } unless @state[:owners][token_id] == from

    @state[:owners][token_id] = to
    { success: true, token_id: token_id, from: from, to: to }
  end

  def owner_of(params)
    token_id = params[:token_id].to_i
    { success: true, owner: @state[:owners][token_id] }
  end
end
