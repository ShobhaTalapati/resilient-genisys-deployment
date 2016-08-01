{% from 'rpms.j2' import source with context %}

include:
   - glassfish-install

{% for property, value in salt['pillar.get']('html-mail-war:jndi').iteritems() %}
set_{{ property }}:
  cmd.script:
    - name: salt://scripts/glassfish_set_custom_jndi_resource.sh
    - args: '{{ property }} "{{ value }}"'
    - require:
      - pkg: install_glassfish_resilient
      - cmd: disble_CDI_feature
    - require_in:
      - pkg: install_html_mail_war
    - stateful: True
{% endfor %}

install_html_mail_war:
  pkg.installed:
    - sources:
      - html-mail-war: salt://rpms/{{ source.dir }}/html-mail-war-{{ salt['pillar.get']('html-mail-war:version') }}.noarch.rpm
    - watch_in:
      - cmd: sleep_while_glassfish_initialises

html_mail_health_check:
  cmd.script:
    - name: salt://scripts/health_check.sh
    - args: '-H {{ grains['fqdn'] }} -p {{ salt['pillar.get']('html-mail-war:healthCheck:port', '8080') }} -u {{ salt['pillar.get']('html-mail-war:healthCheck:url', '/') }} -r {{ salt['pillar.get']('html-mail-war:healthCheck:http_code', '204') }}'
    - require:
      - pkg: install_html_mail_war
      - cmd: sleep_while_glassfish_initialises
      - svn: svn_email_template
    - stateful: True

install_cifs-utils:
  pkg.installed:
    - name: cifs-utils

mount_shared_root:
  mount.mounted:
    - name: {{ salt['pillar.get']('shared_root:target') }}
    - device: {{ salt['pillar.get']('shared_root:source') }}
    - fstype: cifs
    - opts: rw,noperm,user={{ salt['pillar.get']('shared_root:user') }},domain={{ salt['pillar.get']('shared_root:domain') }},password={{ salt['pillar.get']('shared_root:password') }}
    - mkmnt: True
    - dump: 0
    - pass_num: 0
    - require:
      - pkg: install_cifs-utils

install_subversion:
  pkg.installed:
    - name: subversion

svn_email_template:
  svn.export:
    - name: {{ salt['pillar.get']('html-mail-war:template:scm') }}
    - target: {{ salt['pillar.get']('html-mail-war:template:target') }}
    - username: {{ salt['pillar.get']('svn_login:username') }}
    - password: {{ salt['pillar.get']('svn_login:password') }}
    - force: True
    - overwrite: True
    - trust: True
    - require:
      - pkg: install_subversion
      - mount: mount_shared_root
