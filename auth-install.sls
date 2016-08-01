{% from 'rpms.j2' import source with context %}

include:
  - glassfish-install
  - glassfish-directory-install
  - glassfish-log4j-install

install_auth:
  pkg.installed:
    - sources:
      - auth: salt://rpms/{{ source.dir }}/auth-{{ salt['pillar.get']('auth:version') }}.noarch.rpm
    - require:
      - pkg: install_glassfish_resilient
      - pkg: install_glassfish-directory
      - pkg: install_glassfish-log4j
    - watch_in:
      - cmd: sleep_while_glassfish_initialises

auth_health_check:
  cmd.script:
    - name: salt://scripts/health_check.sh
    - args: '-H {{ grains['fqdn'] }} -p {{ salt['pillar.get']('auth:healthCheck:port', '8080') }} -u {{ salt['pillar.get']('auth:healthCheck:url', '/') }} -r {{ salt['pillar.get']('auth:healthCheck:http_code', '204') }}'
    - require:
      - pkg: install_auth
      - cmd: sleep_while_glassfish_initialises
    - stateful: True
