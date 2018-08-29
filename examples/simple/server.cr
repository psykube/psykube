require "http/server"

bind_addr = "0.0.0.0"
port = (ENV["PORT"]? || "8080").to_i

server = HTTP::Server.new do |context|
  context.response.content_type = "text/plain"
  context.response.print "Hello world, got #{context.request.path}!"
end

puts "Listening on http://#{bind_addr}:#{port}"
server.bind_tcp bind_addr, port
server.listen
