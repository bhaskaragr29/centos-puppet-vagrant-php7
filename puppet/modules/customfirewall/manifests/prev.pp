class customfirewall::prev {
    Firewall {
    require => undef,
    }
    # Default firewall rules
    firewall { '000 accept all icmp':
      proto  => 'icmp',
      action => 'accept',
    }->
    firewall { '001 accept all to lo interface':
      proto   => 'all',
      iniface => 'lo',
      action  => 'accept',
    }->
    firewall { '002 reject local traffic not on loopback interface':
      iniface     => '! lo',
      proto       => 'all',
      destination => '127.0.0.1/8',
      action      => 'reject',
    }->
    firewall { '003 accept related established rules':
      proto  => 'all',
      state  => ['RELATED', 'ESTABLISHED'],
      action => 'accept',
    }->
    firewall { '004 accept port 80':
      dport   => 80,
      action => 'accept',
      chain   => 'INPUT',
      proto   => 'tcp',
    }->
    firewall { '008 accept related established rules':
      dport   => 3306,
      action => 'accept',
      chain   => 'INPUT',
      state   => ['NEW'],
      proto   => 'tcp',
    }

}