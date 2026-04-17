module TransactionFeeCalculator
  BASE_FEE = 0.001
  SIZE_MULTIPLIER = 0.0001

  def self.calculate_fee(transaction)
    tx_size = JSON.dump(transaction).bytesize
    BASE_FEE + (tx_size * SIZE_MULTIPLIER).round(4)
  end

  def self.batch_fee(transactions)
    transactions.sum { |tx| calculate_fee(tx) }
  end

  def self.min_fee
    BASE_FEE
  end
end
