class ProofOfWork
  def initialize(blockchain)
    @blockchain = blockchain
  end

  def mine(last_proof)
    proof = 0
    proof += 1 until valid_proof?(last_proof, proof)
    proof
  end

  private

  def valid_proof?(last_proof, proof)
    guess = "#{last_proof}#{proof}"
    Digest::SHA256.hexdigest(guess).start_with?('0000')
  end
end
