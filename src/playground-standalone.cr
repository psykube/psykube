require "./psykube"
require "./playground/server"

puts "Playground Standalone:"
port = (ENV["PORT"]? || 8080).to_i
bind = (ENV["BIND"]? || "127.0.0.1")
Psykube::Playground::Server.listen(port: port, host: bind)
