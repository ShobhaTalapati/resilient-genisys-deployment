{% from 'rpms.j2' import source with context %}

include:
  - glassfish-install
  - glassfish-directory-install
  - glassfish-log4j-install
  - auth-install

install_directory:
  pkg.installed:
    - sources:
      - directory: salt://rpms/{{ source.dir }}/directory-{{ salt['pillar.get']('directory:version') }}.noarch.rpm
    - require:
      - pkg: install_glassfish_resilient
      - pkg: install_glassfish-directory
      - pkg: install_glassfish-log4j
      - pkg: install_auth
    - watch_in:
      - cmd: sleep_while_glassfish_initialises

directory_health_check:
  cmd.script:
    - name: salt://scripts/health_check.sh
    - args: '-H {{ grains['fqdn'] }} -p {{ salt['pillar.get']('directory:healthCheck:port', '8080') }} -u {{ salt['pillar.get']('directory:healthCheck:url', '/') }} -r {{ salt['pillar.get']('directory:healthCheck:http_code', '204') }}'
    - require:
      - pkg: install_directory
      - cmd: sleep_while_glassfish_initialises
    - stateful: True

