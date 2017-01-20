node 'node-01' { 
  include docker 
  class { '::nfs':
        server_enabled => false,
	client_enabled => true,
  }
  nfs::client::mount { '/mnt/nexus':
      server => '192.168.178.143',
      share => '/mnt/disk_1t_raidz/torrent/nexus',
  }
}
node 'nexus' { 
  include docker 
  class { '::nfs':
        server_enabled => false,
	client_enabled => true,
  }
  nfs::client::mount { '/mnt/nexus':
      server => '192.168.178.143',
      share => '/mnt/disk_1t_raidz/torrent',
  } ->
  docker::run { 'nexus':
    image => 'sonatype/nexus3:latest',
    ports => ['8081:8081'],
    hostname => 'nexus',
    volumes => ['/mnt/nexus/nexus:/nexus-data'],
    env => ['JAVA_MAX_MEM=768m','JAVA_MIN_MEM=768m'],
    restart_service => true,
  }

}

