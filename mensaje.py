#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
msg = MIMEMultipart()
correo="""<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body>Buenas,<br>  Ha sido desplegada una nueva versión de la aplicación web comercialesenergeticos.com con nuevos añadidos y corrección de errores:<br>"""
logs = os.popen("cd /var/www/dansaltech && git log")
lines_logs= logs.readlines()
dicciocommits={"add":[],"update":[],"fix":[]}
cont=0
for l in lines_logs:
    if "Merge branch 'master' into despliegue" in l.strip():
        cont=cont+1
    if "update:" in l.strip() or "add:" in l.strip() or "fix:" in l.strip():
        commit=l.strip().split(":")[0]
        message=l.strip().split(";")[0].split(":")[1].split("||")
        for m in message:
            dicciocommits[commit.strip()].append(m.strip())
    if cont > 1:
        break
elementos=dicciocommits.items()
for com, lista  in elementos:
    dicciovalor={"add":"Nuevo","update":"Cambiado","fix":"Arreglado"}
    correo=correo+"<h3>%s</h3><ul>"%(dicciovalor[com])
    for e in lista:
        correo=correo+"<li>"+e+"</li>"
    correo=correo+"</ul>"
correo=correo+"</body></html>"
password = "SYSadmin1234"
msg['From'] = "sysadmin@wolfcrass.com"
tos= ['management@wolfcrass.com','direccion@elegasenergia.com','mvsanchez@wolfcrass.com']
msg['Subject'] = "Despliegue"
msg.attach(MIMEText(correo, 'html'))
server = smtplib.SMTP('smtp.wolfcrass.com: 25')
server.starttls()
server.login(msg['From'], password)
server.sendmail(msg['From'], tos, msg.as_string())
server.quit()
print ("successfully sent email to %s:" % (msg['To']))
