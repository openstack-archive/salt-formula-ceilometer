{%- from "ceilometer/map.jinja" import agent with context %}
{%- if agent.enabled %}

ceilometer_agent_packages:
  pkg.installed:
  - names: {{ agent.pkgs }}

/etc/ceilometer/ceilometer.conf:
  file.managed:
  - source: salt://ceilometer/files/{{ agent.version }}/ceilometer-agent.conf.{{ grains.os_family }}
  - template: jinja
  - require:
    - pkg: ceilometer_agent_packages

{%- for publisher_name, publisher in agent.get('publisher', {}).iteritems() %}

{%- if publisher_name != "default" %}

ceilometer_publisher_{{ publisher_name }}_pkg:
  pkg.latest:
    - name: ceilometer-publisher-{{ publisher_name }}

{%- endif %}

{%- endfor %}

/etc/ceilometer/pipeline.yaml:
  file.managed:
  - source: salt://ceilometer/files/{{ agent.version }}/pipeline.yaml
  - template: jinja
  - require:
    - pkg: ceilometer_agent_packages

{%- if agent.version != "kilo" %}

/etc/ceilometer/event_pipeline.yaml:
  file.managed:
  - source: salt://ceilometer/files/{{ agent.version }}/event_pipeline.yaml
  - template: jinja
  - require:
    - pkg: ceilometer_agent_packages
  - watch_in:
    - service: ceilometer_agent_services

{%- endif %}

ceilometer_agent_services:
  service.running:
  - names: {{ agent.services }}
  - enable: true
  - watch:
    - file: /etc/ceilometer/ceilometer.conf
    - file: /etc/ceilometer/pipeline.yaml

{%- endif %}
