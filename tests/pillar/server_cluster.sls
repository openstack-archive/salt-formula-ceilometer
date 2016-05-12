ceilometer:
  server:
    enabled: true
    version: liberty
    cluster: true
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
      members:
      - host: 127.0.0.1
      - host: 127.0.1.1
      - host: 127.0.2.1
      user: openstack
      password: password
      virtual_host: '/openstack'
    database:
      engine: mongodb
      members:
      - host: 127.0.0.1
        port: 27017
      - host: 127.0.0.1
        port: 27017
      - host: 127.0.0.1
        port: 27017
      name: ceilometer
      user: ceilometer
      password: password
