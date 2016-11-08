class php{

   $php  = hiera('php')
   $version = $php['settings']['version']
   
   $libraries = "modules$version"
   $modules = $php[$libraries]
 
  package { $modules:
      ensure => installed,
      require => Package["epel-release-6"]
  }
  file{ '/etc/php.ini':
    require => [Package['httpd']],
    source  => "puppet:///modules/php/php.ini",
    owner   => 'root',
    mode    => 0644,
    notify  =>  Service['httpd']
  }
}

# class php::phpunit{
#   exec{ 'phpunit':
#     command => "wget https://phar.phpunit.de/phpunit.phar -O phpunit.phar; chmod +x phpunit.phar; mv phpunit.phar /usr/local/bin/phpunit",
#     path => "/usr/local/bin:/bin:/usr/bin",
#     onlyif  => "/usr/bin/test ! -d /usr/local/bin/phpunit",
#     require => File['/etc/php.ini']
#   }
# }