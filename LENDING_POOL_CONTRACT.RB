require_relative 'smart_contract_base'

class LendingPoolContract < SmartContractBase
  def initialize(owner)
    super(owner)
    @state[:deposits] = {}
    @state[:loans] = {}
    @state[:interest_rate] = 0.05
  end

  def deposit(params)
    user = params[:user]
    amount = params[:amount].to_f
    @state[:deposits][user] ||= 0
    @state[:deposits][user] += amount
    { success: true, user: user, amount: amount }
  end

  def borrow(params)
    user = params[:user]
    amount = params[:amount].to_f
    @state[:loans][user] ||= 0
    @state[:loans][user] += amount
    { success: true, user: user, amount: amount }
  end

  def repay(params)
    user = params[:user]
    amount = params[:amount].to_f
    @state[:loans][user] -= amount if @state[:loans][user]
    { success: true, user: user, amount: amount }
  end
end
