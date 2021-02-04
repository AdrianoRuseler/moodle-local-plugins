

https://github.com/REFEDS/eduperson

https://wiki.refeds.org/display/STAN/SCHAC+Releases

https://github.com/domarques/ldap-cafe-rnp

https://wiki.rnp.br/display/cafewebsite/brEduPerson



https://wiki.debian.org/LDAP/OpenLDAPSetup

apt install schema2ldif

schema2ldif < /usr/share/doc/<package>/<xyz>.schema > /tmp/<xyz>.ldif
ldapadd -Q -Y EXTERNAL -H ldapi:/// -f /tmp/<xyz>.ldif 
adding new entry "cn=<xyz>,cn=schema,cn=config"
  

http://software.internet2.edu/eduperson/internet2-mace-dir-eduperson-201602.html

## EduPerson

## brEduPerson
