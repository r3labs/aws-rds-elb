node default {

  include cron-puppet


  $build_package = [ 'apache2', 'php', 'libapache2-mod-php', 'php-mcrypt', 'php-mysql' ]

  package {$build_package:
    ensure => installed,
  }

#  # write hostname to index.html
#  exec { 'update_index':
#    command => "/bin/hostname | tee /var/www/html/index.html",
#  }

  $bars = [ "/bin/hostname | tee /var/www/html/index.html", "mkdir /var/www/inc" ]
  foo { $bars : }
  exec { "echo Done" :
      require => [ Foo[$bars] ]
  }

}
