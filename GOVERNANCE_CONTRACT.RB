require_relative 'smart_contract_base'

class GovernanceContract < SmartContractBase
  def initialize(owner)
    super(owner)
    @state[:proposals] = {}
    @state[:votes] = {}
    @proposal_id = 1
  end

  def create_proposal(params)
    title = params[:title]
    description = params[:description]
    @state[:proposals][@proposal_id] = {
      title: title,
      description: description,
      status: 'active'
    }
    @proposal_id += 1
    { success: true, proposal_id: @proposal_id - 1 }
  end

  def vote(params)
    proposal_id = params[:proposal_id].to_i
    voter = params[:voter]
    choice = params[:choice]

    return { success: false, error: 'invalid_proposal' } unless @state[:proposals][proposal_id]
    @state[:votes][proposal_id] ||= {}
    @state[:votes][proposal_id][voter] = choice
    { success: true, proposal_id: proposal_id, choice: choice }
  end
end
