{% from 'rpms.j2' import source with context %}

include:
   - glassfish-install

{% for property, value in salt['pillar.get']('invoice-notifier:jndi').iteritems() %}
set_{{ property }}:
  cmd.script:
    - name: salt://scripts/glassfish_set_custom_jndi_resource.sh
    - args: '{{ property }} "{{ value }}"'
    - require:
      - pkg: install_glassfish_resilient
      - cmd: disble_CDI_feature
    - require_in:
      - pkg: install_invoice-notifier
    - stateful: True
{% endfor %}

install_invoice-notifier:
  pkg.installed:
    - sources:
      - invoice-notifier-war: salt://rpms/{{ source.dir }}/invoice-notifier-war-{{ salt['pillar.get']('invoice-notifier:version') }}.noarch.rpm
    - watch_in:
      - cmd: sleep_while_glassfish_initialises

invoice-notifier_health_check:
  cmd.script:
    - name: salt://scripts/health_check.sh
    - args: '-H {{ grains['fqdn'] }} -p {{ salt['pillar.get']('invoice-notifier:healthCheck:port', '8080') }} -u {{ salt['pillar.get']('invoice-notifier:healthCheck:url', '/') }} -r {{ salt['pillar.get']('invoice-notifier:healthCheck:http_code', '204') }}'
    - require:
      - pkg: install_invoice-notifier
      - cmd: sleep_while_glassfish_initialises
    - stateful: True
