{% from 'rpms.j2' import source with context %}

include:
  - glassfish-install

install_app-redirection:
  pkg.installed:
    - sources:
      - app-redirection: salt://rpms/{{ source.dir }}/app-redirection-{{ salt['pillar.get']('app-redirection:version') }}.noarch.rpm
    - require:
      - pkg: install_glassfish_resilient
    - watch_in:
      - cmd: sleep_while_glassfish_initialises

app-redirection_health_check:
  cmd.script:
    - name: salt://scripts/health_check.sh
    - args: '-H {{ grains['fqdn'] }} -p {{ salt['pillar.get']('app-redirection:healthCheck:port', '8080') }} -u {{ salt['pillar.get']('app-redirection:healthCheck:url', '/') }} -r {{ salt['pillar.get']('app-redirection:healthCheck:http_code', '200') }}'
    - require:
      - pkg: install_app-redirection
      - cmd: sleep_while_glassfish_initialises
    - stateful: True
