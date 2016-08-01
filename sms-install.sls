{% from 'rpms.j2' import source with context %}

include:
  - glassfish-install
  - glassfish-directory-install
  - glassfish-log4j-install

install_sms:
  pkg.installed:
    - sources:
      - sms: salt://rpms/{{ source.dir }}/sms-{{ salt['pillar.get']('sms:version') }}.noarch.rpm
    - require:
      - pkg: install_glassfish_resilient
      - pkg: install_glassfish-directory
      - pkg: install_glassfish-log4j
    - watch_in:
      - cmd: sleep_while_glassfish_initialises

sms_health_check:
  cmd.script:
    - name: salt://scripts/health_check.sh
    - args: '-H {{ grains['fqdn'] }} -p {{ salt['pillar.get']('sms:healthCheck:port', '8080') }} -u {{ salt['pillar.get']('sms:healthCheck:url', '/') }} -r {{ salt['pillar.get']('sms:healthCheck:http_code', '204') }}'
    - require:
      - pkg: install_sms
      - cmd: sleep_while_glassfish_initialises
    - stateful: True
