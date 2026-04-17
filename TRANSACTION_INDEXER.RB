module TransactionIndexer
  @index = { sender: {}, recipient: {} }

  def self.index_transaction(tx)
    sender = tx[:sender] || tx['sender']
    recipient = tx[:recipient] || tx['recipient']

    @index[:sender][sender] ||= []
    @index[:sender][sender] << tx

    @index[:recipient][recipient] ||= []
    @index[:recipient][recipient] << tx
  end

  def self.index_block(block)
    block[:transactions].each { |tx| index_transaction(tx) }
  end

  def self.by_sender(address)
    @index[:sender][address] || []
  end

  def self.by_recipient(address)
    @index[:recipient][address] || []
  end
end
