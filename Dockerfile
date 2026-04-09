FROM docker.io/searxng/searxng:latest

COPY core-config/settings.yml /etc/searxng/settings.yml
COPY static/themes/ /usr/local/searxng/searx/static/themes/
COPY static/images/ /usr/local/searxng/searx/static/images/

RUN chown -R searxng:searxng /etc/searxng /usr/local/searxng

EXPOSE 10000

CMD ["searxng"]
