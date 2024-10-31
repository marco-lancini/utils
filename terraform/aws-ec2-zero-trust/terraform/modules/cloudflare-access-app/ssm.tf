# ==============================================================================
# SECRETS
# ==============================================================================
resource "aws_ssm_parameter" "main" {
  name        = "/TUNNEL/${var.tunnel_name}/CREDENTIALS"
  description = "${var.tunnel_name} Cloudflared Tunnel: credentials JSON"
  type        = "SecureString"

  value = <<EOF
{
  "AccountTag": "${var.cloudflare_account_id}",
  "TunnelSecret": "${cloudflare_zero_trust_tunnel_cloudflared.main.secret}",
  "TunnelID": "${cloudflare_zero_trust_tunnel_cloudflared.main.id}"
}
EOF

  tags = var.tags
}
