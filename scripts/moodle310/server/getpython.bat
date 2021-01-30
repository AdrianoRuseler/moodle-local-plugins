

curl --output python-3.9.1-embed-amd64.zip --url https://www.python.org/ftp/python/3.9.1/python-3.9.1-embed-amd64.zip

MKDIR python

tar -xvf python-3.9.1-embed-amd64.zip -C python

DEL python-3.9.1-embed-amd64.zip

PAUSE