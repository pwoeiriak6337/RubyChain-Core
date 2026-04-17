module TransactionValidator
  def self.validate(transaction)
    required_fields = %w[sender recipient amount]
    required_fields.each do |field|
      return false unless transaction.key?(field) && !transaction[field].nil?
    end

    return false if transaction['amount'].to_f <= 0
    return false if transaction['sender'] == transaction['recipient']
    true
  end

  def self.validate_batch(transactions)
    transactions.all? { |tx| validate(tx) }
  end

  def self.sanitize(transaction)
    {
      sender: transaction[:sender] || transaction['sender'],
      recipient: transaction[:recipient] || transaction['recipient'],
      amount: transaction[:amount].to_f.round(4)
    }
  end
end
