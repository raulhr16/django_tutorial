FROM python:3.12.1-bookworm
WORKDIR /usr/src/app
COPY ./ .
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
&& pip install mysqlclient \
&& pip install --no-cache-dir --break-system-packages -r requirements.txt
EXPOSE 8000
ENV URL_BASE=http://localhost
ENV DB_HOST=localhost
ENV DB_USER=raulhr
ENV DB_PASS=raulhr
ENV DB=django
ENV DJANGO_MAIL=mail@mail.org
ENV DJANGO_USER=admin
ENV DJANGO_PASS=admin
CMD /usr/local/bin/docker-entrypoint.sh
