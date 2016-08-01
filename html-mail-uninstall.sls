remove_html_mail_war:
   pkg.removed:
     - name: html-mail-war

unmount_shared_root:
   mount.unmounted:
     - name: {{ salt['pillar.get']('shared_root:target') }}
     - device: {{ salt['pillar.get']('shared_root:source') }}
     - persist: False
