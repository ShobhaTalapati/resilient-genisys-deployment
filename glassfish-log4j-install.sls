{% from 'rpms.j2' import source with context %}

include:
  - glassfish-install

install_glassfish-log4j:
  pkg.installed:
    - sources:
      - glassfish-log4j-configuration: salt://rpms/{{ source.dir }}/glassfish-log4j-configuration-{{ salt['pillar.get']('glassfish-log4j-configuration:version') }}.noarch.rpm
    - require:
      - pkg: install_glassfish_resilient
