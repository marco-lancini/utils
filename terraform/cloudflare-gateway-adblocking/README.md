# Serverless Ad Blocking with Cloudflare Gateway

This module automates the setup needed to mimic the Pi-hole's behaviour using only serverless technologies (Cloudflare Gateway, to be precise),
as described in [Serverless Ad Blocking with Cloudflare Gateway](https://blog.marcolancini.it/2022/blog-serverless-ad-blocking-with-cloudflare-gateway/).


## Deploying Resources

In short, this module creates:

* A set of Cloudflare Lists which contain the list of domains to block
* A Cloudflare Gateway Policy which blocks access (at the DNS level) to those domains

![](https://blog.marcolancini.it/images/posts/blog_serverless_adblocking_policies.png)


> ⚠️ This module has been exported from my personal setup, which relies on a monorepo leveraging local modules only.
> 
> Since this module relies on a local text file to store the domain list, it is supposed to be fetched with a local import. If you'd like to fetch it from a remote registry, modifications are required.


## Keeping the domain list up to date

The `action-update-list.yml` provides a sample
GitHub Actions workflow that periodically (monthly) fetches the list upstream and commits it to the repo if it has changed.

![](https://blog.marcolancini.it/images/posts/blog_serverless_adblocking_gh_workflow.png)
