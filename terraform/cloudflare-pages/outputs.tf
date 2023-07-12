output "page_domains" {
  value = cloudflare_pages_project.project.domains
}

output "page_subdomain" {
  value = cloudflare_pages_project.project.subdomain
}
