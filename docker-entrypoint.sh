#!/bin/bash
export DJANGO_SUPERUSER_PASSWORD=$DJANGO_PASS
cd /usr/src/app
curl https://raw.githubusercontent.com/vishnubob/wait-for-it/refs/heads/master/wait-for-it.sh > wait-for-it.sh
chmod +x wait-for-it.sh
./wait-for-it.sh db:3306 --timeout=30 --strict
python3 manage.py migrate
python3 manage.py createsuperuser --username $DJANGO_USER --email $DJANGO_MAIL --noinput
python3 manage.py runserver 0.0.0.0:8000
