node default {

  include cron-puppet

  # install apache2 package
  package { 'apache2':
    ensure => installed,
    notify => Exec['update_index']
  }

  # write hostname to index.html
  exec { 'update_index':
    command => "/bin/hostname | tee /var/www/html/index.html",
  }

}
