secrets=%w(
MYSQL_PASSWORD=secret
SECRET_KEY_BASE=123
MYSQL_ROOT_PASSWORD=topsecret
)

require "base64"

secrets.each do |secret|
  key, value = secret.split("=")
  value = Base64.encode64(value)
  puts "#{key}: #{value}"
end
