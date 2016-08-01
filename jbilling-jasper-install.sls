{% from 'rpms.j2' import source with context %}

include:
  - glassfish-install

install_jbilling_jasper:
  pkg.installed:
    - sources:
      - jbilling-jasper: salt://rpms/{{ source.dir }}/jbilling-jasper-{{ salt['pillar.get']('jbilling-jasper:version') }}.noarch.rpm
    - require:
      - pkg: install_glassfish
    - watch_in:
      - cmd: sleep_while_glassfish_initialises

jbilling_jasper_health_check:
  cmd.script:
    - name: salt://scripts/health_check.sh
    - args: '-H {{ grains['fqdn'] }} -p {{ salt['pillar.get']('jbilling-jasper:healthCheck:port', '8080') }} -u {{ salt['pillar.get']('jbilling-jasper:healthCheck:url', '/') }} -r {{ salt['pillar.get']('jbilling-jasper:healthCheck:http_code', '204') }}'
    - require:
      - pkg: install_jbilling_jasper
      - cmd: sleep_while_glassfish_initialises
    - stateful: True
