Chef-solo deploy scripts.
=========================

Tested on Ubuntu 12.04

### How to use

Mostly you use deploy.sh command. You can also read [Mastering chef-solo: deploy to target machines and automatic run on boot](http://distinctplace.com/infrastructure/2013/08/18/mastering-chef-solo-deploy-to-target-machines-and-automatic-run-on-boot/) for usage examples.

Options:

* -f - first boot ( uses one ssh connection string over the default one, at the moment hardcoded to the srcipt, **adjust for your use case** or provide  a switch which will set host dynamically.

* -h fqdn - sets the hostname, before chef run

`./deploy.sh -f -h mix.domain.com`

**YOU MAY NEED TO ADJUST SOME VALUES IN THE SCRIPT TO FIT YOUR OWN NEEDS!**
