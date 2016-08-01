{% from 'rpms.j2' import source with context %}

install_subversion:
  pkg.installed:
    - name: subversion

https://subversion.teamphone.priv/svn/source/qa/trunk/platforms/{{ grains['env'] }}/installerproperties/{{ grains['host'] }}-Installer.properties/:
  svn.export:
     - target:   /root/{{ grains['host'] }}-Installer.properties
     - username:  DevelopmentDaemon
     - password:  F15hturbu1ence!
     - trust:   True
     - force: True
     - overwrite: True

{% if "proc" in salt['grains.get']('roles')  %}
https://subversion.teamphone.priv/svn/source/qa/trunk/platforms/numbering-plan/CORE-12_numberingplan.xlsm/:
  svn.export:
     - target:   /opt/april-billing-processor-files
     - username:  DevelopmentDaemon
     - password:  F15hturbu1ence!
     - trust:   True
     - force: True
     - overwrite: True

/opt/april-billing-processor-files:
  file.directory:
    -  user: glassfish
    -  group: glassfish
    -  mode: 660
    - recurse:
      - user
      - group
      - mode
{% endif %}

properties_exists:
  file.exists:
  - name: /root/{{ grains['host'] }}-Installer.properties

# glassfish-resilient requires root's /env(HOME)/HOSTNAME-Installer.properties, HOME isn't expected to be set without a login shell
env_set_home:
  environ.setenv:
    - name: HOME
    - value: /root

install_glassfish:
  pkg.installed:
    - sources:
      - glassfish: salt://rpms/{{ source.dir }}/glassfish-{{ salt['pillar.get']('glassfish:version') }}.noarch.rpm
    - require:
      - file: properties_exists

install_glassfish_resilient:
  pkg.installed:
    - sources:
      - glassfish-resilient: salt://rpms/{{ source.dir }}/glassfish-resilient-{{ salt['pillar.get']('glassfish-resilient:version') }}.noarch.rpm
    - require:
      - pkg: install_glassfish

start_glassfish:
  service.running:
    - name: glassfish
    - require:
      - pkg: install_glassfish
      - pkg: install_glassfish_resilient

{% if "public_api" in salt['grains.get']('roles')  %}
force_gf_start:
  cmd.wait:
    - name: 'service glassfish start'
    - watch:
      - pkg: install_glassfish
{% endif %}

{% if "private_api" in salt['grains.get']('roles')  %}
disble_CDI_feature:
  cmd.run:
    - name: /opt/glassfish/glassfish/bin/asadmin set configs.config.server-config.cdi-service.enable-implicit-cdi=false
    - require:
      - service: start_glassfish
{% endif %}

sleep_while_glassfish_initialises:
  cmd.wait:
    - name: /bin/bash -c 'sleep {{ salt['pillar.get']('glassfish:sleep', '20') }}'
