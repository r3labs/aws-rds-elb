node default {

  include cron-puppet


  $package_list = [ 'apache2', 'php', 'libapache2-mod-php', 'php-mcrypt', 'php-mysql' ]

  packages {'install':
    ensure => installed,
    before => Package['build']
  }

  # write hostname to index.html
#  exec { 'update_index':
#    command => "/bin/hostname | tee /var/www/html/index.html",
#    command => "apt install -y php libapache2-mod-php php-mcrypt php-mysql",
#    command => "systemctl restart apache2",
#    command => "groupadd www",
#    command => "usermod -a -G www ubuntu",
#    command => "chown -R root:www /var/www",
#    command => "chmod 2775 /var/www",
#    command => "find /var/www -type d -exec sudo chmod 2775 {} +",
#    command => "find /var/www -type f -exec sudo chmod 0664 {} +",
#    command => "cd /var/www",
#    command => "mkdir inc",
#  }

}
