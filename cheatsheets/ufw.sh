# Install
apt-get install ufw

# Setup, default deny & allow SSH
ufw default deny incoming
ufw enable
ufw allow 22
ufw status

# Enable connection from src to port
ufw allow from $src to any port $port

# Enable multiple ports
ufw allow proto tcp from any to any port 9999,443

# Delete deny rule on port 80
ufw delete deny 80
