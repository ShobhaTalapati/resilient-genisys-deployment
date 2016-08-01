{% if "portal_api" in salt['grains.get']('roles')  %}
include:
  - reporting-uninstall
{% endif %}
{% if "april_proc" in salt['grains.get']('roles')  %}
include:
  - cdr-reporting-proc-uninstall
{% endif %}

remove_glassfish-sqlserver:
  pkg.removed:
    - name: glassfish-sqlserver-jdbc-driver
    {% if "portal_api" in salt['grains.get']('roles')  %}
    - require:
      - sls: reporting-uninstall
    {% endif %}
    {% if "april_proc" in salt['grains.get']('roles')  %}
    - require:
      - sls: cdr-reporting-proc-uninstall
    {% endif %}

