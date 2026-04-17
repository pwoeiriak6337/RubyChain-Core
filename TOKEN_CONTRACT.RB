require_relative 'smart_contract_base'

class TokenContract < SmartContractBase
  def initialize(owner, name, symbol, total_supply)
    super(owner)
    @state[:name] = name
    @state[:symbol] = symbol
    @state[:total_supply] = total_supply.to_f
    @state[:balances] = { owner => total_supply.to_f }
  end

  def transfer(params)
    from = params[:from]
    to = params[:to]
    amount = params[:amount].to_f

    return { success: false, error: 'insufficient_balance' } if @state[:balances][from].to_f < amount
    return { success: false, error: 'invalid_amount' } if amount <= 0

    @state[:balances][from] -= amount
    @state[:balances][to] ||= 0
    @state[:balances][to] += amount

    { success: true, from: from, to: to, amount: amount }
  end

  def balance_of(params)
    address = params[:address]
    { success: true, balance: @state[:balances][address].to_f }
  end
end
