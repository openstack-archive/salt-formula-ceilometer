
==========
Ceilometer
==========

The ceilometer project aims to deliver a unique point of contact for billing systems to acquire all of the measurements they need to establish customer billing, across all current OpenStack core components with work underway to support future OpenStack components.

Sample pillars
==============

Ceilometer API/controller node

.. code-block:: yaml

    ceilometer:
      server:
        enabled: true
        version: havana
        cluster: true
        secret: pwd
        bind:
          host: 127.0.0.1
          port: 8777
        identity:
          engine: keystone
          host: 127.0.0.1
          port: 35357
          tenant: service
          user: ceilometer
          password: pwd
        message_queue:
          engine: rabbitmq
          members:
            - host: 10.0.16.1
            - host: 10.0.16.2
            - host: 10.0.16.3
          user: openstack
          password: pwd
          virtual_host: '/openstack'
        database:
          engine: mongodb
          host: 127.0.0.1
          port: 27017
          name: ceilometer
          user: ceilometer
          password: pwd

Ceilometer Graphite publisher

.. code-block:: yaml

    ceilometer:
      server:
        enabled: true
        publisher:
          graphite:
            enabled: true
            host: 10.0.0.1
            port: 2003

Ceilometer compute agent

.. code-block:: yaml

    ceilometer:
      agent:
        enabled: true
        version: havana
        secret: pwd
        identity:
          engine: keystone
          host: 127.0.0.1
          port: 35357
          tenant: service
          user: ceilometer
          password: pwd
        message_queue:
          engine: rabbitmq
          members:
            - host: 10.0.16.1
            - host: 10.0.16.2
            - host: 10.0.16.3
          user: openstack
          password: pwd
          virtual_host: '/openstack'


Read more
=========

* https://wiki.openstack.org/wiki/Ceilometer
* http://docs.openstack.org/developer/ceilometer/install/manual.html
* http://docs.openstack.org/developer/ceilometer/
* https://fedoraproject.org/wiki/QA:Testcase_OpenStack_ceilometer_install
* https://github.com/spilgames/ceilometer_graphite_publisher
* http://engineering.spilgames.com/using-ceilometer-graphite/

Things to improve/consider
==========================

* Graphite publisher http://engineering.spilgames.com/using-ceilometer-graphite/
* Juno additions - Split Events/Meters and Alarms databases, Polling angets are HA now, active/Activr Workload partitioning to central agents
* Kilo additions - Splint Events - Meters - Agents, notification agents are HA now (everything is HA now), events - elastic search
* User notifier publisher vs rpc publisher (Juno+)
* Enable jittering (rendom delay) to polling. (Kilo+)
* Collect what you need - pipeline.yaml, tweak polling interval (Icehouse+)
* add more agents as load inceases (Juno+)
* Avoid open-ended queries - query on a time range
* Install api behind mod_wsgi, tweak wsgi daemon - threads and processes
* Set TTL - expire data to minimise database size
* Run Mongodb on separate node - use sharding and replica-sets

Deployment scenarios
--------------------

* Lambda design - use short term and long term databases in the same time
* Data segragation - separatem
* JSON files - Apache spark
* Fraud detection - proprietary alarming system
* Custom consumers - kafka - Apache Storm (kilo+)
* Debugging - Collecttions - Elastic serach - Kibana
* Noisy services - Multiple notification buses
