node default {

  include cron-puppet

  $build_package = [ 'apache2', 'php', 'libapache2-mod-php', 'php-mcrypt', 'php-mysql' ]
  package {$build_package:
    ensure => installed,
  }

  $bars = [ "/bin/hostname | tee /var/www/html/index.html", "/bin/mkdir /var/www/inc" ]
  exec { $bars :
  }

}
