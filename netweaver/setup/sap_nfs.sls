{%- from "netweaver/map.jinja" import netweaver with context -%}
{% set host = grains['host'] %}

{% for node in netweaver.nodes if host == node.host and node.use_nfs|default(True) %}

{% set instance = '{:0>2}'.format(node.instance) %}
{% set instance_name =  node.sid~'_'~instance %}

mount_sapmnt_{{ instance_name }}:
  mount.mounted:
    - name: /sapmnt
    - device: {{ netweaver.sapmnt_inst_media }}/sapmnt
    - fstype: nfs
    - mkmnt: True
    - persist: True
    - opts:
      - defaults

mount_usersapsys_{{ instance_name }}:
  mount.mounted:
    - name: /usr/sap/{{ node.sid.upper() }}/SYS
    - device: {{ netweaver.sapmnt_inst_media }}/usrsapsys
    - fstype: nfs
    - mkmnt: True
    - persist: True
    - opts:
      - defaults

{% if netweaver.clean_nfs and node.sap_instance == 'ascs' %}

clean_nfs_sapmnt_{{ instance_name }}:
  file.absent:
    - name: /sapmnt/{{ node.sid.upper() }}

clean_nfs_usr_{{ instance_name }}:
  file.directory:
    - name: /usr/sap/{{ node.sid.upper() }}/SYS
    - clean: True

{% endif %}

{% endfor %}
