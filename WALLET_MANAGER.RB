require_relative 'crypto_utils'

class WalletManager
  attr_reader :address, :public_key, :private_key

  def initialize
    keys = CryptoUtils.generate_key_pair
    @private_key = keys[:private]
    @public_key = keys[:public]
    @address = generate_wallet_address
  end

  def sign_transaction(transaction)
    data = JSON.dump(transaction)
    CryptoUtils.sign_data(@private_key, data)
  end

  def verify_transaction(transaction, signature)
    data = JSON.dump(transaction)
    CryptoUtils.verify_signature(@public_key, data, signature)
  end

  private

  def generate_wallet_address
    Digest::SHA256.hexdigest(@public_key)[0...42]
  end
end
