base:
   'localminion':
       - rpms
   'roles:private_api':
       - match: grain
       - glassfish-install
       - html-mail-install
       - invoice-notifier-install
   'roles:private_api_gf3':
       - match: grain
       - glassfish-install
       - glassfish-directory-install
       - glassfish-log4j-install
   'roles:portal_api':
       - match: grain
       - glassfish-install
       - portal-install
       - glassfish-sqlserver-install
       - reporting-install
       - jbilling-jasper-install
   'roles:april_proc':
       - match: grain
       - glassfish-install
       - glassfish-log4j-install
       - glassfish-sqlserver-install
       - april-billing-proc-install
       - cdr-reporting-proc-install
   'roles:public_api':
       - match: grain
       - glassfish-install
       - glassfish-log4j-install
       - glassfish-directory-install
       - auth-install
       - account-management-install
       - app-redirection-install
       - dial-install
       - directory-install
       - sms-install
       - smartnumbers-web-install 
   'roles:jbilling_api':
       - match: grain
       - jbilling-api-install
   'roles:jbilling_batch':
       - match: grain
       - jbilling-batch-install
