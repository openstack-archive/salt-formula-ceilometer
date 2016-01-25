ceilometer:
  server:
    enabled: true
    version: liberty
    secret: password
    ttl: 86400
    publisher:
      default:
    bind:
      host: 127.0.0.1
      port: 8777
    identity:
      engine: keystone
      host: 127.0.0.1
      port: 35357
      tenant: service
      user: ceilometer
      password: password
    message_queue:
      engine: rabbitmq
      host: 127.0.0.1
      port: 5672
      user: openstack
      password: password
      virtual_host: '/openstack'
      ha_queues: true
      # Workaround for https://bugs.launchpad.net/ceilometer/+bug/1337715
      rpc_thread_pool_size: 5
    database:
      engine: mongodb
      host: 127.0.0.1
      port: 27017
      name: ceilometer
      user: ceilometer
      password: password
