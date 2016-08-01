{% if "public_api" in salt['grains.get']('roles')  %}
include:
  - auth-uninstall
  - dial-uninstall
  - directory-uninstall
  - sms-uninstall
{% endif %}

remove_glassfish_directory:
  pkg.removed:
    - name: glassfish-directory-configuration
    {% if "public_api" in salt['grains.get']('roles')  %}
    - require:
      - sls: auth-uninstall
      - sls: dial-uninstall
      - sls: directory-uninstall
      - sls: sms-uninstall
    {% endif %}
