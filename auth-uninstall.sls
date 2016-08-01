{% if "public_api" in salt['grains.get']('roles')  %}
include:
  - directory-uninstall
{% endif %}

remove_auth:
  pkg.removed:
    - name: auth
    {% if "public_api" in salt['grains.get']('roles')  %}
    - require:
      - sls: directory-uninstall
    {% endif %}