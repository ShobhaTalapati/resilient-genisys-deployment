include:
{% if "private_api" in salt['grains.get']('roles')  %}
  - html-mail-uninstall
  - invoice-notifier-uninstall
{% endif %}
{% if "private_api_gf3" in salt['grains.get']('roles')  %}
  - glassfish-directory-uninstall
  - glassfish-log4j-uninstall
{% endif %}
{% if "portal_api" in salt['grains.get']('roles')  %}
  - portal-uninstall
  - glassfish-sqlserver-uninstall
  - jbilling-jasper-uninstall
{% endif %}
{% if "public_api" in salt['grains.get']('roles')  %}
  - auth-uninstall
  - account-management-uninstall
  - app-redirection-uninstall
  - dial-uninstall
  - directory-uninstall
  - sms-uninstall
  - smartnumbers-web-uninstall
  - glassfish-directory-uninstall
  - glassfish-log4j-uninstall
{% endif %}
{% if "april_proc" in salt['grains.get']('roles')  %}
  - cdr-reporting-proc-uninstall
  - april-billing-proc-uninstall
  - glassfish-log4j-uninstall
  - glassfish-sqlserver-uninstall
{% endif %}

stop_glassfish:
  service.dead:
    - name: glassfish
    - order: 1

remove_glassfish_resilient:
  pkg.removed:
    - name: glassfish-resilient
    - require:
      {% if "private_api" in salt['grains.get']('roles')  %}
      - sls: html-mail-uninstall
      - sls: invoice-notifier-uninstall
      {% endif %}
      {% if "private_api_gf3" in salt['grains.get']('roles')  %}
      - sls: glassfish-directory-uninstall
      - sls: glassfish-log4j-uninstall
      {% endif %}
      {% if "portal_api" in salt['grains.get']('roles')  %}
      - sls: portal-uninstall
      {% endif %}
      {% if "public_api" in salt['grains.get']('roles')  %}
      - sls: auth-uninstall
      - sls: account-management-uninstall
      - sls: app-redirection-uninstall
      - sls: dial-uninstall
      - sls: directory-uninstall
      - sls: sms-uninstall
      - sls: smartnumbers-web-uninstall
      - sls: glassfish-directory-uninstall
      - sls: glassfish-log4j-uninstall
      {% endif %}
      {% if "april_proc" in salt['grains.get']('roles')  %}
      - sls: cdr-reporting-proc-uninstall
      - sls: april-billing-proc-uninstall
      - sls: glassfish-log4j-uninstall
      - sls: glassfish-sqlserver-uninstall
      {% endif %}

remove_glassfish:
  pkg.removed:
    - name: glassfish
    - require:
      - pkg: remove_glassfish_resilient
      - service : stop_glassfish
      {% if "portal_api" in salt['grains.get']('roles')  %}
      - sls: glassfish-sqlserver-uninstall
      - sls: jbilling-jasper-uninstall
      {% endif %}
