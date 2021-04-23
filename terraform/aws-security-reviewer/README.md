# AWS Security Reviewer

This module automate the setup of roles and users to be used for implementing an Hub and Spoke model, as described in [Cross Account Auditing in AWS and GCP](https://www.marcolancini.it/2019/blog-cross-account-auditing/).

In short, this module can be used to create:

1. One role (`role_security_audit`) in every AWS account (Hub + all the Spoke ones), with the built-in `SecurityAudit` policy attached to it.
2. One role (`role_security_assume`), in the Hub account, able to assume the `role_security_audit` role on all the Spoke accounts.
3. One IAM user (`user_security_audit`), in the Hub account, able to assume the `role_security_assume` role. Access keys for this user are not managed via this module.

![](https://www.marcolancini.it/images/posts/blog_cross_account_auditing_AWS.png)


## Usage

From the Hub account:
```terraform
locals {
  account_id  = "AAAAAAAAAAAA"
}

module "security_reviewer" {
  source = "../<path>/security-reviewer"
  providers = {
    aws = aws.ireland
  }

  hub_account_id = local.account_id
  is_hub         = true
}
```

From a Spoke account:
```terraform
locals {
  master_id  = "AAAAAAAAAAAA"
  account_id = "BBBBBBBBBBBB"
}

module "security_reviewer" {
  source = "../<path>/security-reviewer"
  providers = {
    aws = aws.ireland
  }

  hub_account_id = local.master_id
  is_hub         = false
}
```


## Variables

| Name                   | Default                | Description                                                                       |
| ---------------------- | ---------------------- | --------------------------------------------------------------------------------- |
| `is_hub`               | `false`                | Whether the current account has to be used as Hub                                 |
| `hub_account_id`       |                        | The ID of the AWS account to be used as Hub                                       |
| `role_audit_name`      | `role_security_audit`  | The name of the role used for security auditing                                   |
| `role_assume_name`     | `role_security_assume` | The name of the role able to assume `role_audit_name`                             |
| `security_user_name`   | `user_security_audit`  | The name of the IAM user able to assume the roles                                 |
| `max_session_duration` | `21600` (6 hours)      | Maximum session duration (in seconds) that you want to set for the specified role |
