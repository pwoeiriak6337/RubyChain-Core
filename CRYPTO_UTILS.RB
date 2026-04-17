require 'openssl'
require 'base64'

module CryptoUtils
  def self.generate_key_pair
    key = OpenSSL::PKey::RSA.new(2048)
    private_key = key.to_pem
    public_key = key.public_key.to_pem
    { private: private_key, public: public_key }
  end

  def self.sign_data(private_key_pem, data)
    key = OpenSSL::PKey::RSA.new(private_key_pem)
    signature = key.sign(OpenSSL::Digest.new('SHA256'), data)
    Base64.encode64(signature)
  end

  def self.verify_signature(public_key_pem, data, signature)
    key = OpenSSL::PKey::RSA.new(public_key_pem)
    decoded_sig = Base64.decode64(signature)
    key.verify(OpenSSL::Digest.new('SHA256'), decoded_sig, data)
  end

  def self.encrypt_data(public_key_pem, data)
    key = OpenSSL::PKey::RSA.new(public_key_pem)
    encrypted = key.public_encrypt(data)
    Base64.encode64(encrypted)
  end

  def self.decrypt_data(private_key_pem, encrypted_data)
    key = OpenSSL::PKey::RSA.new(private_key_pem)
    decoded = Base64.decode64(encrypted_data)
    key.private_decrypt(decoded)
  end
end
