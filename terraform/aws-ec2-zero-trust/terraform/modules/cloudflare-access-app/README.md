# Cloudflare Access App

Create a Cloudflare Access application.

This module creates:

- A self-hosted Cloudflare Access application, with an access policy that requires a user to be a member of a specified group in order to access the application.
- A Cloudflare Tunnel that connects the application to a specified origin server.
- A DNS Record that points to the Cloudflare Tunnel.
- An SSM Parameter that contains the Cloudflare Tunnel configuration (ID/secret).
