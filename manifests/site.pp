node default {

  include cron-puppet

  $build_package = [ 'apache2', 'php', 'libapache2-mod-php', 'php-mcrypt', 'php-mysql' ]

  package { $build_package :
    require => Class["cron-puppet"],
    ensure => installed,
  }

  group { "www" :
    require => Package[$build_package],
    ensure => present,
  }

  user { "ubuntu" :
    require => Group["www"],
    ensure => present,
    groups => "www",
  }

  file { "set_dirs" :
    require => User["ubuntu"],
    name => "/var/www",
    ensure => directory,
    owner => root,
    group => www,
    mode => 2775,
    recurse => true,
  }

  file { "set_index" :
    require => File["set_dirs"],
    name => "/var/www/html/index.html",
    ensure => file,
    owner => root,
    group => www,
    mode => 0664,
    recurse => true,
  }

  $cmds = [
    "/bin/hostname | tee /var/www/html/index.html",
    "/bin/chown -R root:www /var/www",
    "/bin/chmod 2775 /var/www",
    "/usr/bin/find /var/www -type d -exec sudo chmod 2775 {} +",
    "/usr/bin/find /var/www -type f -exec sudo chmod 0664 {} +",
    "/bin/mkdir /var/www/inc",
  ]

#  exec { $cmds :
#    require => User["ubuntu"],
#  }

}
