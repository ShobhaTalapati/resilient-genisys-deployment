{% from 'rpms.j2' import source with context %}

include:
  - glassfish-install

install_account-management:
  pkg.installed:
    - sources:
      - account-management: salt://rpms/{{ source.dir }}/account-management-{{ salt['pillar.get']('account-management:version') }}.noarch.rpm
    - require:
      - pkg: install_glassfish_resilient
    - watch_in:
      - cmd: sleep_while_glassfish_initialises

account-management_health_check:
  cmd.script:
    - name: salt://scripts/health_check.sh
    - args: '-H {{ grains['fqdn'] }} -p {{ salt['pillar.get']('account-management:healthCheck:port', '8080') }} -u {{ salt['pillar.get']('account-management:healthCheck:url', '/') }} -r {{ salt['pillar.get']('account-management:healthCheck:http_code', '200') }}'
    - require:
      - pkg: install_account-management
      - cmd: sleep_while_glassfish_initialises
    - stateful: True
