{% from 'rpms.j2' import source with context %}

include:
  - glassfish-install
  - glassfish-directory-install

install_dial:
  pkg.installed:
    - sources:
      - dial: salt://rpms/{{ source.dir }}/dial-{{ salt['pillar.get']('dial:version') }}.noarch.rpm
    - require:
      - pkg: install_glassfish_resilient
      - pkg: install_glassfish-directory
    - watch_in:
      - cmd: sleep_while_glassfish_initialises

dial_health_check:
  cmd.script:
    - name: salt://scripts/health_check.sh
    - args: '-H {{ grains['fqdn'] }} -p {{ salt['pillar.get']('dial:healthCheck:port', '8080') }} -u {{ salt['pillar.get']('dial:healthCheck:url', '/') }} -r {{ salt['pillar.get']('dial:healthCheck:http_code', '204') }}'
    - require:
      - pkg: install_dial
      - cmd: sleep_while_glassfish_initialises
    - stateful: True
