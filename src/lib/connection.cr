require "file_utils"
require "socket"

module AllqClient
  class Connection
    UNIX_SOCKET_PATH        = ENV["ALLQ_SOCKET"]? || "/tmp/allq_client.sock"
    ALLQ_LOCAL_TCP_URL_PORT = ENV["ALLQ_LOCAL_TCP_URL_PORT"]?

    def initialize
      if ALLQ_LOCAL_TCP_URL_PORT
        url, port = ALLQ_LOCAL_TCP_URL_PORT.to_s.split(":", 2)
        @socket = TCPSocket.new(url, port.to_i)
      else
        raise "Cannot find allq_client socket at #{UNIX_SOCKET_PATH}" unless File.exists?(UNIX_SOCKET_PATH)
        @socket = UNIXSocket.new(UNIX_SOCKET_PATH)
      end
    end

    def send(data)
      result = ""
      begin
        if @socket
          @socket.puts(data)
          @socket.flush
          result = @socket.gets
          @socket.close
          reload_socket
        end
      rescue ex
        puts ex.message
        reload_socket
      end
      result
    end

    def reload_socket
      if ALLQ_LOCAL_TCP_URL_PORT
        url, port = ALLQ_LOCAL_TCP_URL_PORT.to_s.split(":", 2)
        @socket = TCPSocket.new(url, port.to_i)
      else
        raise "Cannot find allq_client socket at #{UNIX_SOCKET_PATH}" unless File.exists?(UNIX_SOCKET_PATH)
        @socket = UNIXSocket.new(UNIX_SOCKET_PATH)
      end
    end
  end
end
