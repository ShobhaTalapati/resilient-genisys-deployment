install_cifs:
   pkg.installed:
     - name: cifs-utils

mount_installers:
   mount.mounted:
     - name: {{ salt['pillar.get']('installers:target') }}
     - device: {{ salt['pillar.get']('installers:source') }}
     - fstype: cifs
     - opts: ro,noperm,user={{ salt['pillar.get']('installers:user') }},domain={{ salt['pillar.get']('installers:domain') }},password={{ salt['pillar.get']('installers:password') }}
     - mkmnt: True
     - dump: 0
     - pass_num: 0
     - require:
       - pkg: install_cifs

symlink_installers:
   file.symlink:
     - name: "{{ salt['pillar.get']('installers:symlinks:name') }}"
     - target: "{{ salt['pillar.get']('installers:symlinks:target') }}"
     - force: True
     - makedirs: True
     - backupname: "{{ salt['pillar.get']('installers:symlinks:name') }}.old"
