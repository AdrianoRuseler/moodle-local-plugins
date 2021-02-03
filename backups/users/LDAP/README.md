

https://github.com/REFEDS/eduperson

https://wiki.refeds.org/display/STAN/SCHAC+Releases

https://github.com/domarques/ldap-cafe-rnp


apt install schema2ldif

schema2ldif < /usr/share/doc/<package>/<xyz>.schema > /tmp/<xyz>.ldif
ldapadd -Q -Y EXTERNAL -H ldapi:/// -f /tmp/<xyz>.ldif 
adding new entry "cn=<xyz>,cn=schema,cn=config"
  
