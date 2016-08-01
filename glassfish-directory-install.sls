{% from 'rpms.j2' import source with context %}

include:
  - glassfish-install

install_glassfish-directory:
  pkg.installed:
    - sources:
      - glassfish-directory-configuration: salt://rpms/{{ source.dir }}/glassfish-directory-configuration-{{ salt['pillar.get']('glassfish-directory-configuration:version') }}.noarch.rpm
    - require:
      - pkg: install_glassfish_resilient
