
# stage {'pre':
# 	before => Stage['main']
# }

stage {'post':
    require => Stage['main'],
}

class {'customfirewall':
  stage => 'post'
}

package {
	'unzip': ensure => installed;
 
}

if($::operatingsystem == "CentOS") and ($::operatingsystemmajrelease == "6"){
	$epelrel = hiera('epelrelease')
	$webstatic = hiera('webstatic')
	package { "epel-release-6":
        provider => rpm,
        ensure  =>  present,
        source => $epelrel['rpm'],
        install_options => ['-ivh','--replacepkgs'],
	}->
	package { "webstatic":       
		ensure  =>  installed,
	    source  => $webstatic['rpm'],
	    provider=> rpm,
	    install_options => ['-ivh','--replacepkgs'];
	}	
} else {
	fail("Current puppet scripts supports: \'$::operatingsystemmajrelease\'")
}


class cntlm{

	package { 'cntlm':
  			ensure => '0.92.3-1',
  			provider 	=> 'rpm',
			source  	=> '/vagrant/cntlm-0.92.3-1.x86_64.rpm',
	}

	file{ '/etc/cntlm.conf':
		path	=> '/etc/cntlm.conf',
		require => Package['cntlm'],
		source => '/vagrant/puppet/cntlm.conf',
		owner	=> 'root',
		mode	=> 0600,
		notify =>  Service['cntlmd'],
	}



	service { 'cntlmd':
		enable      => true,
		ensure      => running,
		require    => [Package["cntlm"], File['/etc/cntlm.conf']],
	}
}


# class {'jenkins':
#   configure_firewall => false,
#   executors => 4,
# }

include httpd, php, customfirewall