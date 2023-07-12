# Cloudflare Pages with Zero Trust Authentication

This module creates a Cloudflare Pages application with Zero Trust Authentication,
where only the `allowed_emails` are allowed to access the application.


## Usage

```hcl
module "web" {
  source = "<path>/cloudflare-pages"

  cloudflare_account_id = "..."
  cloudflare_zone_id    = "..."

  # Name of the Pages application
  name = "web"

  # Full domain name: test.example.com
  hostname = "test"
  domain   = "example.com

  # Authentication
  zero_trust     = true
  allowed_emails = ["admin@example.com"]
}
```
