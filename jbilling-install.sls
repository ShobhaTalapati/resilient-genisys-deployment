{% from 'rpms.j2' import source with context %}

stop_tomcat:
  service.dead:
    -  name:  tomcat

install_jbilling_api:
  pkg.installed:
    - sources:
      - jbilling: salt://rpms/{{ source.dir }}/jbilling-{{ salt['pillar.get']('jbilling:version') }}.noarch.rpm
      - jbilling-api-config: salt://rpms/{{ source.dir }}/jbilling-api-config-{{ salt['pillar.get']('jbilling-api-config:version') }}.noarch.rpm
      - jbilling-liquibase: salt://rpms/{{ source.dir }}/jbilling-liquibase-{{ salt['pillar.get']('jbilling-liquibase:version') }}.noarch.rpm

{% if "alpha-env" in salt['grains.get']('env') %}
/opt/tomcat/jbilling-resources/jbilling-DataSource.groovy:
   file.replace:
    - name: /opt/tomcat/jbilling-resources/jbilling-DataSource.groovy
    - pattern:  JBilling_DB 
    - repl:  Hurricane-JbillingDB
    - count: 1
    - show_changes: True
    - name: /opt/tomcat/jbilling-resources/jbilling-DataSource.groovy
    - pattern: LT_SQL_LST
    - repl:  QA_SQL_JB_LST
    - count: 1   
 
/opt/tomcat/jbilling-resources/jbilling.properties:
   file.replace:
    - name: /opt/tomcat/jbilling-resources/jbilling.properties
    - pattern:  <jbilling-arr>
    - repl:  WGCDOHC-JBARR01.teamphone.qa
    - count: 1
    - pattern:  <set to the latest license key>
    - repl:  HSw+mBkHiSdIdPYrHEgGEmszHqlBwG8hr1khS6+q4xGmgBtx0Y+fVVmwENh70/x8x3hcZLSSdTd0AB7vBZE+AoIKwzA7f8ul8InPpLdXSyJRsQr+6/0RQBALZIgtXYIh
    - count:  1
    - show_changes: True
{% endif %}

start_tomcat:
   service.running:
    - name: tomcat
