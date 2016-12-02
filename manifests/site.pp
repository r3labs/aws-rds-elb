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
    source  => 'puppet:///files/dbinfo.inc',
    mode    => 0664,
    owner   => root,
    group   => www,
  }

  exec { $cmds :
    require => Package[$build_package],
    command => "/bin/hostname | tee /var/www/html/index.html",
  }

}
