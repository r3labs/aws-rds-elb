$script = <<SCRIPT
sudo apt-get update
sudo apt-get install puppet -y
sudo apt-get install git-core -y
mv /etc/puppet/ /etc/puppet-bak
git clone https://github.com/r3labs/aws-rds-elb.git /etc/puppet
/usr/bin/puppet apply /etc/puppet/manifests/site.pp
SCRIPT

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"

  config.vm.network "forwarded_port", guest: 80, host: 3000

  config.vm.provision "shell", inline: $script

end