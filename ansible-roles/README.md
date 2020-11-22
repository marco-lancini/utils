# Ansible Roles

This folder contains some useful Ansible roles for setting up dev workstations.


## Roles

| Role              | Description                                                  |
| ----------------- | ------------------------------------------------------------ |
| `dev-os`          | Setup OS for Ubuntu dev                                      |
| `dev-sw`          | Install software for Ubuntu dev                              |
| `dev-vscode`      | Install VSCode                                               |
| `docker`          | Install docker on Linux                                      |
| `golang`          | Install golang on Linux                                      |
| `kali-cloud`      | Install tools to perform cloud assessments (AWS, Azure, GCP) |
| `kali-metasploit` | Install MSF, configure Postgres, setup msfdb and Armitage    |
| `kali-os`         | Update OS, setup locales, add users, config ufw and zsh      |
| `kali-red`        | For red teams (empire, dnscat2, etc.)                        |
| `kali-sw`         | Install basic maintenance, dev, and pt tools                 |
| `mobile-android`  | Android tools                                                |
| `mobile-ios`      | iOS tools                                                    |


## Installation

```bash
$ service ssh start
$ sudo apt install sshpass python-pip
$ sudo pip install ansible

# Create user vagrant
$ adduser vagrant
$ usermod -aG sudo vagrant
$ ssh vagrant@127.0.0.1

# At the end, remove user
userdel vagrant
```

## Usage

* Specify hosts
```bash
$ cat /etc/ansible/hosts
  [local]
  127.0.0.1
```

* Run test command
```bash
$ ansible all -m ping -s -k -u vagrant --ask-sudo-pass
#     -m <module>	= run module
#     -s	        = sudo
#     -k	        = ask for password
#     -u <user>	  = run as user
```

* Run playbook
```bash
$ ansible-playbook -s -k -u vagrant --ask-sudo-pass nginx.yml
```

* Choose Roles
```bash
$ cat /etc/ansible/ansible.cfg
  [defaults]
  roles_path    = /vagrant/ansible/roles

$ cat server.yml
    ---
    - hosts: all
      roles:
        - nginx

$ ansible-playbook -s -k -u vagrant --ask-sudo-pass server.yml
```
