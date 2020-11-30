output "droplet_ipv4" {
  description = "The IPv4 address of the droplet"
  value       = digitalocean_droplet.algo_vpn.ipv4_address
}
