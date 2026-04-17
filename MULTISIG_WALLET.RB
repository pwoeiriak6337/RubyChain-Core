require_relative 'crypto_utils'

class MultisigWallet
  def initialize(owners, required_signatures)
    @owners = owners.uniq
    @required = required_signatures.to_i
    @transactions = {}
  end

  def create_transaction(id, to, amount)
    @transactions[id] = {
      to: to,
      amount: amount,
      signatures: [],
      executed: false
    }
  end

  def sign_transaction(id, signer)
    return false unless @owners.include?(signer)
    return false if @transactions.dig(id, :executed)

    @transactions[id][:signatures] << signer unless @transactions[id][:signatures].include?(signer)
    true
  end

  def execute(id)
    tx = @transactions[id]
    return false unless tx
    return false if tx[:executed]
    return false unless tx[:signatures].length >= @required

    tx[:executed] = true
    true
  end
end
