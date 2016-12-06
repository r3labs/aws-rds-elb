class elb_rds {

  package { 'apache2' :
    ensure => installed,
  }

  package { 'php' :
    ensure => installed,
    require => Package['apache2'],
  }

  package { 'libapache2-mod-php' :
    ensure => installed,
    require => Package['php'],
  }

  package { 'php-mcrypt' :
    ensure => installed,
    require => Package['libapache2-mod-php'],
  }

  package { 'php-mysql' :
    ensure => installed,
    require => Package['php-mcrypt'],
  }

  group { 'www' :
    ensure => present,
    require => Package['php-mysql'],
  }

  user { 'ubuntu' :
    ensure => present,
    require => Group['www'],
    groups => 'www',
  }

  file { 'set_dirs' :
    ensure => directory,
    require => User['ubuntu'],
    name => '/var/www',
    owner => root,
    group => www,
    mode => '2775',
    recurse => true,
  }

  file { 'set_index' :
    ensure => file,
    require => File['set_dirs'],
    name => '/var/www/html/index.html',
    owner => root,
    group => www,
    mode => '0664',
    recurse => true,
  }

  file { 'dir_inc' :
    ensure => directory,
    require => File['set_index'],
    name => '/var/www/inc',
    owner => root,
    group => www,
    mode => '2775',
  }

  file { 'file_inc':
    ensure  => file,
    require => File['dir_inc'],
    path    => '/var/www/inc/dbinfo.inc',
    source  => 'puppet:///modules/elb-rds/dbinfo.inc',
    mode    => '0664',
    owner   => root,
    group   => www,
  }

  file { 'file_php':
    ensure  => file,
    require => File['file_inc'],
    path    => '/var/www/html/SamplePage.php',
    source  => 'puppet:///modules/elb-rds/SamplePage.php',
    mode    => '0664',
    owner   => root,
    group   => www,
  }

  exec { 'write_index' :
    require => File['file_php'],
    command => '/bin/hostname | tee /var/www/html/index.html',
  }

  exec { 'restart_apache2' :
    require => Exec['write_index'],
    command => '/bin/systemctl restart apache2',
  }

}