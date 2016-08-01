{% from 'rpms.j2' import source with context %}

include:
  - glassfish-install

install_glassfish-sqlserver:
  pkg.installed:
    - sources:
      - glassfish-sqlserver-jdbc-driver: salt://rpms/{{ source.dir }}/glassfish-sqlserver-jdbc-driver-{{ salt['pillar.get']('glassfish-sqlserver-jdbc-driver:version') }}.noarch.rpm
    - require:
      - pkg: install_glassfish
