module TransactionPool
  @pool = []

  def self.add(transaction)
    return false unless valid_transaction?(transaction)
    return false if exists?(transaction)
    @pool << transaction
    true
  end

  def self.remove(transaction)
    @pool.delete(transaction)
  end

  def self.clear
    @pool = []
  end

  def self.get_all
    @pool.dup
  end

  def self.exists?(transaction)
    tx_hash = hash_transaction(transaction)
    @pool.any? { |tx| hash_transaction(tx) == tx_hash }
  end

  private

  def self.valid_transaction?(tx)
    tx.key?('sender') && tx.key?('recipient') && tx['amount'].to_f > 0
  end

  def self.hash_transaction(tx)
    Digest::SHA256.hexdigest(JSON.dump(tx))
  end
end
