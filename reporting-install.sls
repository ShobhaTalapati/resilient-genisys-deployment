{% from 'rpms.j2' import source with context %}

include:
  - glassfish-sqlserver-install

install_reporting:
  pkg.installed:
    - sources:
      - reporting: salt://rpms/{{ source.dir }}/reporting-{{ salt['pillar.get']('reporting:version') }}.noarch.rpm
    - require:
      - sls: glassfish-sqlserver-install
    - watch_in:
      - cmd: sleep_while_glassfish_initialises

reporting_health_check:
  cmd.script:
    - name: salt://scripts/health_check.sh
    - args: '-H {{ grains['fqdn'] }} -p {{ salt['pillar.get']('reporting:healthCheck:port', '8080') }} -u {{ salt['pillar.get']('reporting:healthCheck:url', '/') }} -r {{ salt['pillar.get']('reporting:healthCheck:http_code', '204') }}'
    - require:
      - pkg: install_reporting
      - cmd: sleep_while_glassfish_initialises
    - stateful: True
