class elb-rds {

#  $build_package = [ 'apache2', 'php', 'libapache2-mod-php', 'php-mcrypt', 'php-mysql' ]

#  package { $build_package :
#    ensure => installed,
#  }

  package { "apache2" :
    ensure => installed,
  }

  package { "php" :
    require => Package["apache2"],
    ensure => installed,
  }

  package { "libapache2-mod-php" :
    require => Package["php"],
    ensure => installed,
  }

  package { "php-mcrypt" :
    require => Package["libapache2-mod-php"],
    ensure => installed,
  }

  package { "php-mysql" :
    require => Package["php-mcrypt"],
    ensure => installed,
  }

  group { "www" :
    require => Package["php-mysql"],
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

  file { "dir_inc" :
    require => File["set_index"],
    name => "/var/www/inc",
    ensure => directory,
    owner => root,
    group => www,
    mode => 2775,
  }

  file { 'file_inc':
    require => File["dir_inc"],
    ensure  => file,
    path    => '/var/www/inc/dbinfo.inc',
    source  => 'puppet:///modules/elb-rds/dbinfo.inc',
    mode    => 0664,
    owner   => root,
    group   => www,
  }

  file { 'file_php':
    require => File["file_inc"],
    ensure  => file,
    path    => '/var/www/html/SamplePage.php',
    source  => 'puppet:///modules/elb-rds/SamplePage.php',
    mode    => 0664,
    owner   => root,
    group   => www,
  }

  exec { "write_index" :
    require => File["file_php"],
    command => "/bin/hostname | tee /var/www/html/index.html",
  }

  exec { "restart_apache2" :
    require => Exec["write_index"],
    command => "/bin/systemctl restart apache2",
  }

}