{%- from "ceilometer/map.jinja" import server with context %}
{%- if server.enabled %}

{%- if server.version >= "mitaka" %}

# Mitaka based deployment doesn't need a collector and alarm packages and services,
# because alarm functionality are implemented by Aodh and collector stuff is implemented
# by ceilometer_collector
ceilometer_server_packages:
  pkg.installed:
  - names: {{ server.basic_pkgs + server.db_module_pkgs }}

{%- else %}

ceilometer_server_packages:
  pkg.installed:
  - names: {{ server.basic_pkgs + server.collector_pkgs + server.alarm_pkgs }}

{%- endif %}


/etc/ceilometer/ceilometer.conf:
  file.managed:
  - source: salt://ceilometer/files/{{ server.version }}/ceilometer-server.conf.{{ grains.os_family }}
  - template: jinja
  - require:
    - pkg: ceilometer_server_packages

{%- for publisher_name, publisher in server.get('publisher', {}).iteritems() %}

{%- if publisher_name != "default" %}

ceilometer_publisher_{{ publisher_name }}_pkg:
  pkg.latest:
    - name: ceilometer-publisher-{{ publisher_name }}

{%- endif %}

{%- endfor %}

/etc/ceilometer/pipeline.yaml:
  file.managed:
  - source: salt://ceilometer/files/{{ server.version }}/pipeline.yaml
  - template: jinja
  - require:
    - pkg: ceilometer_server_packages

{%- if server.version != "kilo" %}

/etc/ceilometer/event_pipeline.yaml:
  file.managed:
  - source: salt://ceilometer/files/{{ server.version }}/event_pipeline.yaml
  - template: jinja
  - require:
    - pkg: ceilometer_server_packages
  - watch_in:
    - service: ceilometer_server_services

/etc/ceilometer/event_definitions.yaml:
  file.managed:
  - source: salt://ceilometer/files/{{ server.version }}/event_definitions.yaml
  - template: jinja
  - require:
    - pkg: ceilometer_server_packages
  - watch_in:
    - service: ceilometer_server_services

/etc/ceilometer/gabbi_pipeline.yaml:
  file.managed:
  - source: salt://ceilometer/files/{{ server.version }}/gabbi_pipeline.yaml
  - template: jinja
  - require:
    - pkg: ceilometer_server_packages
  - watch_in:
    - service: ceilometer_server_services

{%- endif %}


{%- if server.version >= "mitaka" %}

ceilometer_server_services:
  service.running:
  - names: {{ server.basic_services }}
  - enable: true
  - watch:
    - file: /etc/ceilometer/ceilometer.conf

{%- else %}

ceilometer_server_services:
  service.running:
  - names: {{ server.basic_services + server.alarm_services + server.collector_services }}
  - enable: true
  - watch:
    - file: /etc/ceilometer/ceilometer.conf

{%- endif %}


{%- endif %}
