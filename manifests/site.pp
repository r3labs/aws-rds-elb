node default {

  include cron-puppet

  $build_package = [ 'apache2', 'php', 'libapache2-mod-php', 'php-mcrypt', 'php-mysql' ]

  package {$build_package:
    ensure => installed,
  }

  $cmds = [
    "/bin/hostname | tee /var/www/html/index.html",
    "/usr/sbin/groupadd www",
    "/usr/sbin/usermod -a -G www ubuntu",
    "/bin/chown -R root:www /var/www"
    "/bin/chmod 2775 /var/www",
    "/bin/mkdir /var/www/inc",
  ]

  exec { $cmds :
  }

}
