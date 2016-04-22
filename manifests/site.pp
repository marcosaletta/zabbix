#Definition of the first proxy node (a zabbix agent it is also installed)
node 'puppet-master.openstacklocal' {

  class { 'apache':
    mpm_module => 'prefork',
  }
  include apache::mod::php
  include apt


   #Installation of the mysql database
   class { 'mysql::server':
     root_password    => 'lgnf,mn3cm',
     override_options => {
            'mysqld'       => {
                'bind_address' => '192.168.20.13',
        },
      },
    }
  #Installation of the mysql client (optional)
  class { 'mysql::client': }

  #Installation of the zabbix proxy with definition of database parameters
  class { 'zabbix::proxy':
    zabbix_server_host => '141.250.2.121',
    manage_database    => true,
    zabbix_server_port => '10051',
    database_type      => 'mysql',
    database_host      => 'localhost',
    mode               => '0',
    hostname           => 'Proxy',
    externalscripts    => '/usr/lib/zabbix/externalscripts/zabbix-external-scripts',
    offlinebuffer       => '720',
    timeout            => '30',
    database_name     => 'zabbix-proxy',
    database_user     => 'zabbix-proxy',
    database_password => 'zabbix-proxy',
  }
 
  #Installation of the zabbix agent
  class { 'zabbix::agent':
    manage_resources   => true,
    serveractive        => '172.16.1.27',
    startagents        => '0',
  }
  
  #Clone of the external scripts for zabbix from the repository 
  class { 'root-git::clone': 
    repo => 'zabbix-external',
    #select what type of scripts will be used, iaas or metrics 
    external => 'iaas' 
  }

}


#Definition of the second proxy node (a zabbix agent it is also installed)
node 'puppet-agent.openstacklocal' {

  class { 'apache':
    mpm_module => 'prefork',
  }
  include apache::mod::php

  #Installation of the mysql database
  class { 'mysql::server':
     root_password    => 'lgnf,mn3cm',
     override_options => {
       'mysqld'       => {
          'bind_address' => '192.168.20.13',
        },
      },
    }

  #Installation of the zabbix proxy with definition of database parameters
  class { 'zabbix::proxy':
    zabbix_server_host => 'puppet-agent.openstacklocal',
    manage_database    => true,
    zabbix_server_port => '10051',
    database_type      => 'mysql',
    mode               => '0',
    hostname           => 'Proxy',
    externalscripts    => '/usr/lib/zabbix/externalscripts/zabbix-external-scripts',
    #debuglevel         => '4',
    offlinebuffer       => '720',
    timeout            => '30',
    database_name     => 'zabbix-proxy',
    database_user     => 'zabbix-proxy',
    database_password => 'zabbix-proxy',
    database_host     => 'localhost',

  }

  #Installation of the zabbix agent
  class { 'zabbix::agent':
    manage_resources   => true,
    #monitored_by_proxy => '172.16.1.29',
    #server             => '192.168.20.11'
    serveractive        => '172.16.1.29,172.16.1.30,172.16.1.31',
    startagents        => '0',
  }

  #Clone of the external scripts for zabbix from the repository
  class { 'root-git::clone':
    repo => 'zabbix-external',
    #select what type of scripts will be used, iaas or metrics
    external => 'metrics'
  }
}


node 'monocolo.openstacklocal' {

  class { 'apache':
    mpm_module => 'prefork',
  }
  include apache::mod::php

  #Installation of the mysql database
  class { 'mysql::server':
     root_password    => 'lgnf,mn3cm',
     override_options => {
       'mysqld'       => {
          'bind_address' => '192.168.20.13',
        },
      },
    }

  #Installation of the zabbix proxy with definition of database parameters
  class { 'zabbix::proxy':
    zabbix_server_host => 'monocolo.openstacklocal',
    manage_database    => true,
    zabbix_server_port => '10051',
    database_type      => 'mysql',
    mode               => '0',
    hostname           => 'Proxy',
    externalscripts    => '/usr/lib/zabbix/externalscripts/zabbix-external-scripts',
    #debuglevel         => '4',
    offlinebuffer       => '720',
    timeout            => '30',
    database_name     => 'zabbix-proxy',
    database_user     => 'zabbix-proxy',
    database_password => 'zabbix-proxy',
    database_host     => 'localhost',

  }

  #Installation of the zabbix agent
  class { 'zabbix::agent':
    manage_resources   => true,
    #monitored_by_proxy => '172.16.1.29',
    #server             => '192.168.20.11'
    serveractive        => '172.16.1.29,172.16.1.30,172.16.1.31',
    startagents        => '0',
  }

  #Clone of the external scripts for zabbix from the repository
  class { 'root-git::clone':
    repo => 'zabbix-external',
    #select what type of scripts will be used, iaas or metrics
    external => 'iaas'
  }



}

