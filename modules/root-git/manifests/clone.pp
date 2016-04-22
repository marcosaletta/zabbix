class root-git::clone ($repo, $username='devchick', $external) {
#    $group = $username
#    group { $username:
#        ensure  => present,
#        gid     => 2000,
#    }
#
#    user { $username:
#       ensure  => present,
#       gid     => $group,
#       require => Group[$group],
#       uid     => 2000,
#       home    => "/home/${username}",
#       shell   => "/bin/bash",
#       managehome  => true,
#   }
#
#    file { '/opt/code' :
#        ensure  => directory,
#        group   => $group,
#        owner   => $username,
#        mode    => 0755,
#    }
#
#    file { '/home/${username}':
#        ensure  => directory,
#        group   => $group,
#        owner   => $username,
#        mode    => 0700,
#    }
   
   #Check that the git package is installed
    package { 'git':
        ensure => installed,
    }
   #Clone the repository 
    vcsrepo { "/opt/code/${repo}":
        ensure   => latest,
        owner    => zabbix,
        group    => zabbix,
        provider => git,
        require  => [ Package["git"] ],
        source   => "https://baltig.infn.it/OCP-MONITORING/zabbix-external-scripts.git",
        revision => 'master',
    }

#Cp the selected external scripts in the right forlder 
file { '/usr/lib/zabbix/externalscripts/zabbix-external-scripts':
        ensure  => directory,
        group   => zabbix,
        owner   => zabbix,
        mode    => 0700,
        source  => "/opt/code/${repo}/external-script-${external}",
        recurse => true,
    }
    
    #Cp credentials from the template to the actual file 
    file { "/usr/lib/zabbix/externalscripts/zabbix-external-scripts/credentials.conf":
        group   => zabbix,
        owner   => zabbix,
        mode    => 0600,
  	source  => "/usr/lib/zabbix/externalscripts/zabbix-external-scripts/credentials_template.conf",
  	#recurse => true,
    }
#Cp token from the template to the actual file
file { "/usr/lib/zabbix/externalscripts/zabbix-external-scripts/token_backup":
        group   => zabbix,
        owner   => zabbix,
        mode    => 0600,
        source  => "/usr/lib/zabbix/externalscripts/zabbix-external-scripts/token_backup_template",
    }



}
