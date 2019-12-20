{%- from "netweaver/map.jinja" import netweaver with context -%}
{% set host = grains['host'] %}

{% for node in netweaver.nodes if node.host == host and node.sap_instance == 'cal' %}

install_sap_cal:
  sapcal.is_installed:
    - name: {{ node.cal_folder }}
    - sid_adm_password: {{ netweaver.sid_adm_password|default(netweaver.master_password) }}
    - root_user: {{ node.root_user }}
    - root_password: {{ node.root_password }}
    - force: {{ node.force }}

{% endfor %}
