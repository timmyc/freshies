set :stage, :production

# Replace 127.0.0.1 with your server's IP address!
server '198.58.117.11', port: '8058', user: 'deploy', roles: %w{web app}
