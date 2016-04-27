{%- if grains['saltversion'] >= "2016.3.0" %}

{# Batch execution is necessary - usable after 2016.3.0 release #}
ceilometer.server:
  salt.state:
    - tgt: 'ceilometer:server'
    - tgt_type: pillar
    - batch: 1
    - sls: ceilometer.server
    - require:
      - salt: keystone.server

{%- else %}

{# Workaround for cluster with up to 3 members #}
ceilometer.server:
  salt.state:
    - tgt: '*01* and I@ceilometer:server'
    - tgt_type: compound
    - sls: ceilometer.server
    - require:
      - salt: keystone.server

ceilometer.server.02:
  salt.state:
    - tgt: '*02* and I@ceilometer:server'
    - tgt_type: compound
    - sls: ceilometer.server
    - require:
      - salt: keystone.server

ceilometer.server.03:
  salt.state:
    - tgt: '*03* and I@ceilometer:server'
    - tgt_type: compound
    - sls: ceilometer.server
    - require:
      - salt: keystone.server

{%- endif %}

