variable "do_token" {
  description = "Digital Ocean authentication token"
}

variable "private_key" {
  description = "SSH Private Key to be used by the remote provisioner"
}

variable "public_key" {
  description = "SSH Public Key to be added to the authorized_keys of the Droplet"
}

variable "droplet_name" {
  description = "Name of the Droplet"
  default     = "algo-vpn"
}

variable "droplet_region" {
  description = "Region of the Droplet"
  default     = "lon1"
}

variable "droplet_image" {
  description = "Image of the Droplet"
  default     = "ubuntu-20-04-x64"
}

variable "droplet_size" {
  description = "Size of the Droplet"
  default     = "s-1vcpu-1gb"
}
