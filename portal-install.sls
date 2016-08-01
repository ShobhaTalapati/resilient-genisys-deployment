{% from 'rpms.j2' import source with context %}

include:
  - glassfish-install

install_portal:
  pkg.installed:
    - sources:
      - portal: salt://rpms/{{ source.dir }}/portal-{{ salt['pillar.get']('portal:version') }}.noarch.rpm
      - portal-web: salt://rpms/{{ source.dir }}/portal-web-{{ salt['pillar.get']('portal-web:version') }}.noarch.rpm
    - require:
      - pkg: install_glassfish_resilient
    - watch_in:
      - cmd: sleep_while_glassfish_initialises

portal_health_check:
  cmd.script:
    - name: salt://scripts/health_check.sh
    - args: '-H {{ grains['fqdn'] }} -p {{ salt['pillar.get']('portal:healthCheck:port', '8080') }} -u {{ salt['pillar.get']('portal:healthCheck:url', '/') }} -r {{ salt['pillar.get']('portal:healthCheck:http_code', '204') }}'
    - require:
      - pkg: install_portal
      - cmd: sleep_while_glassfish_initialises
    - stateful: True

portal_web_health_check:
  cmd.script:
    - name: salt://scripts/health_check.sh
    - args: '-H {{ grains['fqdn'] }} -p {{ salt['pillar.get']('portal-web:healthCheck:port', '8080') }} -u {{ salt['pillar.get']('portal-web:healthCheck:url', '/') }} -r {{ salt['pillar.get']('portal-web:healthCheck:http_code', '200') }}'
    - require:
      - pkg: install_portal
      - cmd: sleep_while_glassfish_initialises
    - stateful: True
