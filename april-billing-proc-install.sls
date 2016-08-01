{% from 'rpms.j2' import source with context %}

include:
  - glassfish-install
  - glassfish-log4j-install

install_april-billing-proc:
  pkg.installed:
    - sources:
      - april-billing-processor: salt://rpms/{{ source.dir }}/april-billing-processor-{{ salt['pillar.get']('april-billing-processor:version') }}.noarch.rpm
    - require:
      - pkg: install_glassfish_resilient
      - pkg: install_glassfish-log4j
    - watch_in:
      - cmd: sleep_while_glassfish_initialises

april-billing-processor_health_check:
  cmd.script:
    - name: salt://scripts/health_check.sh
    - args: '-H {{ grains['fqdn'] }} -p {{ salt['pillar.get']('april-billing-processor:healthCheck:port', '8080') }} -u {{ salt['pillar.get']('april-billing-processor:healthCheck:url', '/') }} -r {{ salt['pillar.get']('dial:healthCheck:http_code', '204') }}'
    - require:
      - pkg: install_april-billing-proc
      - cmd: sleep_while_glassfish_initialises
    - stateful: True
