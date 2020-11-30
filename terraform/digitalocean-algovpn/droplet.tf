resource "digitalocean_droplet" "algo_vpn" {
  name   = var.droplet_name
  region = var.droplet_region
  image  = var.droplet_image
  size   = var.droplet_size

  ssh_keys = [digitalocean_ssh_key.tf.id]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.private_key)
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # Install dependencies
      "apt -y update",
      "apt -y upgrade",
      "apt install -y --no-install-recommends python3-virtualenv python3-pip",
      # Clone Algo
      "git clone https://github.com/trailofbits/algo",
      "cd algo",
      # Install Algo
      "python3 -m virtualenv --python=/usr/bin/python3 .env && . .env/bin/activate && python3 -m pip install -U pip virtualenv && python3 -m pip install -r requirements.txt"
    ]
  }
}

resource "digitalocean_ssh_key" "tf" {
  name       = "tf"
  public_key = file(var.public_key)
}
