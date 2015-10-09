Perfect Vagrant
===============

## Getting Started

- Install [VirtualBox](https://www.virtualbox.org)
- Install [Vagrant](https://www.vagrantup.com)
- Install Vagrant Plugins (see below)

```
$ vagrant plugin install vagrant-cachier
$ vagrant plugin install vagrant-host-shell
$ vagrant plugin install vagrant-hostsupdater
```

- Clone this repository
- Update `config.default.json` as appropriate
- From within the cloned repository's folder, run `$ vagrant up`
- SSH into the box (see below)

```
$ vagrant ssh
```

If you have left the default values in place (`config.default.json`), the server
should now be accessible at: 10.0.3.20 / server.site
