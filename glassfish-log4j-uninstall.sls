{% if "public_api" in salt['grains.get']('roles')  %}
include:
  - auth-uninstall
  - directory-uninstall
  - sms-uninstall
{% endif %}

{% if "april_proc" in salt['grains.get']('roles')  %}
include:
  - april-billing-proc-uninstall
  - cdr-reporting-proc-uninstall
{% endif %}

remove_glassfish_log4j:
  pkg.removed:
    - name: glassfish-log4j-configuration
    {% if "public_api" in salt['grains.get']('roles')  %}
    - require:
      - sls: auth-uninstall
      - sls: directory-uninstall
      - sls: sms-uninstall
    {% endif %} 
    {% if "april_proc" in salt['grains.get']('roles')  %}
    - require:
      - sls: april-billing-proc-uninstall
      - sls: cdr-reporting-proc-uninstall
    {% endif %}

