
include:
{% if pillar.ceilometer.agent is defined %}
- ceilometer.agent
{% endif %}
{% if pillar.ceilometer.server is defined %}
- ceilometer.server
{% endif %}
