FROM docker.io/searxng/searxng:latest

# Install envsubst (needed to substitute env vars)
RUN apk add --no-cache gettext

# Copy and process settings.yml with environment variables
COPY core-config/settings.yml /tmp/settings.yml.template
RUN envsubst < /tmp/settings.yml.template > /etc/searxng/settings.yml

COPY static/themes/ /usr/local/searxng/searx/static/themes/
COPY static/images/ /usr/local/searxng/searx/static/images/

RUN chown -R searxng:searxng /etc/searxng /usr/local/searxng

EXPOSE 10000

CMD ["searxng"]
