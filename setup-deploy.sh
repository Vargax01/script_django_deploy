#!/bin/bash
GIT_URL=$1
cont=`echo $GIT_URL | grep -o / | wc -l`
cont=$(($cont+1))
carpeta_proyecto=`echo $GIT_URL | cut -d"/" -f$cont`
if [ -d /var/www/$carpeta_proyecto ];
then
	sudo rm -r /var/www/$carpeta_proyecto
fi
git clone $GIT_URL /var/www/$carpeta_proyecto
sudo chmod -R 777 /var/www/$carpeta_proyecto
.local/bin/virtualenv /var/www/$carpeta_proyecto
source /var/www/$carpeta_proyecto/bin/activate
pip3 install -r /var/www/$carpeta_proyecto/requirements.txt
PYTHON_V=`python -V`
PYTHON_V1=`echo ${PYTHON_V//[[:blank:]]/} | tr '[:upper:]' '[:lower:]' | cut -d"." -f1`
PYTHON_V2=`echo ${PYTHON_V//[[:blank:]]/} | tr '[:upper:]' '[:lower:]' | cut -d"." -f2`
PYTHON_V=`echo $PYTHON_V1"."$PYTHON_V2`
deactivate
DNS=`/home/ubuntu/script_django_deploy/json-bash.sh DNS /var/www/$carpeta_proyecto/params.json | cut -d" " -f2`
SITE_APACHE=`/home/ubuntu/script_django_deploy/json-bash.sh SITE_APACHE /var/www/$carpeta_proyecto/params.json | cut -d" " -f2`
NOMBRE_PROYECTO=`/home/ubuntu/script_django_deploy/json-bash.sh NOMBRE_PROYECTO /var/www/$carpeta_proyecto/params.json | cut -d" " -f2`
P_NAME=`echo $NOMBRE_PROYECTO | cut -d"_" -f1`
P_NAME=`echo $NOMBRE_PROYECTO"_project"`
ERROR_LOG=`echo $NOMBRE_PROYECTO"_error.log"`
ACCESS_LOG=`echo $NOMBRE_PROYECTO"_access.log"`
sudo cp -R /var/www/$carpeta_proyecto/lib/$PYTHON_V/site-packages/django/contrib/admin/static/admin/ /var/www/$carpeta_proyecto/$P_NAME/static/
if [ ! -f /etc/apache2/sites-enabled/$site_apache ];
then
	cp /home/ubuntu/script_django_deploy/template-site.conf /home/ubuntu/script_django_deploy/template-site.conf.tmp
	sed -i 's/$PROJECT_NAME/'$P_NAME'/g' /home/ubuntu/script_django_deploy/template-site.conf.tmp
	sed -i 's/$PROJECT_FOLDER/'$carpeta_proyecto'/g' /home/ubuntu/script_django_deploy/template-site.conf.tmp
	sed -i 's/$SERVER_NAME/'$DNS'/g' /home/ubuntu/script_django_deploy/template-site.conf.tmp
	sed -i 's/$ERROR_LOG/'$ERROR_LOG'/g' /home/ubuntu/script_django_deploy/template-site.conf.tmp
	sed -i 's/$ACCESS_LOG/'$ACCESS_LOG'/g' /home/ubuntu/script_django_deploy/template-site.conf.tmp
	sudo cp /home/ubuntu/script_django_deploy/template-site.conf.tmp /etc/apache2/sites-enabled/$site_apache
fi
sudo a2ensite $SITE_APACHE
sudo systemctl restart apache2
