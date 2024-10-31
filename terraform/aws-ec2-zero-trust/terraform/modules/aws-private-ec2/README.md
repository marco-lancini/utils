# Private EC2 Instance

Create a private EC2 instance (in a public subnet though).

This module creates:

- A VPC with a public subnet and an Internet Gateway
- A security group that only allows egress to the internet
- An optional security group to allow SSH access
- A role for the instance that allows usage of SSM
- An EC2 instance with the AMI, user_data, and keypair provided

