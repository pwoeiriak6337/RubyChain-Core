require 'socket'

class PeerConnection
  def initialize(host = '0.0.0.0', port = 5000)
    @host = host
    @port = port
    @peers = []
  end

  def start_server
    server = TCPServer.new(@host, @port)
    puts "Peer node running on #{@host}:#{@port}"

    loop do
      peer = server.accept
      @peers << peer
      Thread.new { handle_peer(peer) }
    end
  end

  def connect_to_peer(remote_host, remote_port)
    peer = TCPSocket.new(remote_host, remote_port)
    @peers << peer
    Thread.new { handle_peer(peer) }
  end

  def broadcast(message)
    @peers.each { |peer| peer.puts(message) rescue nil }
  end

  private

  def handle_peer(peer)
    while (line = peer.gets)
      process_message(line.chomp)
    end
  rescue StandardError
    @peers.delete(peer)
  end

  def process_message(message)
    data = JSON.parse(message)
    puts "Received peer message: #{data['type']}"
  end
end
