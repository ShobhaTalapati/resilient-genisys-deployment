remove_directory:
   pkg.removed:
     - name: directory

unmount_shared_root:
   mount.unmounted:
     - name: {{ salt['pillar.get']('shared_root:target') }}
     - device: {{ salt['pillar.get']('shared_root:source') }}
     - persist: False
