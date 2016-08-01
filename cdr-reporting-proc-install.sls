{% from 'rpms.j2' import source with context %}

include:
  - glassfish-install
  - glassfish-log4j-install
  - glassfish-sqlserver-install

install_cdr-reporting-proc:
  pkg.installed:
    - sources:
      - cdr-reporting-processor: salt://rpms/{{ source.dir }}/cdr-reporting-processor-{{ salt['pillar.get']('cdr-reporting-processor:version') }}.noarch.rpm
    - require:
      - pkg: install_glassfish_resilient
      - pkg: install_glassfish-log4j
      - pkg: install_glassfish-sqlserver
    - watch_in:
      - cmd: sleep_while_glassfish_initialises

cdr-reporting-processor_health_check:
  cmd.script:
    - name: salt://scripts/health_check.sh
    - args: '-H {{ grains['fqdn'] }} -p {{ salt['pillar.get']('cdr-reporting-processor:healthCheck:port', '8080') }} -u {{ salt['pillar.get']('cdr-reporting-processor:healthCheck:url', '/') }} -r {{ salt['pillar.get']('dial:healthCheck:http_code', '204') }}'
    - require:
      - pkg: install_cdr-reporting-proc
      - cmd: sleep_while_glassfish_initialises
    - stateful: True
