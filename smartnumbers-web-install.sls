{% from 'rpms.j2' import source with context %}

include:
  - glassfish-install

install_smartnumbers-web:
  pkg.installed:
    - sources:
      - smartnumbers-web: salt://rpms/{{ source.dir }}/smartnumbers-web-{{ salt['pillar.get']('smartnumbers-web:version') }}.noarch.rpm
    - require:
      - pkg: install_glassfish_resilient
    - watch_in:
      - cmd: sleep_while_glassfish_initialises

smartnumbers-web_health_check:
  cmd.script:
    - name: salt://scripts/health_check.sh
    - args: '-H {{ grains['fqdn'] }} -p {{ salt['pillar.get']('smartnumbers-web:healthCheck:port', '8080') }} -u {{ salt['pillar.get']('smartnumbers-web:healthCheck:url', '/') }} -r {{ salt['pillar.get']('smartnumbers-web:healthCheck:http_code', '200') }}'
    - require:
      - pkg: install_smartnumbers-web
      - cmd: sleep_while_glassfish_initialises
    - stateful: True
