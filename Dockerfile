FROM docker.io/searxng/searxng:latest

# Clone the theme repo
RUN apk add --no-cache git
RUN git clone https://github.com/simply-nord/simply-nord.git /tmp/theme-repo

COPY searxng-custom/core-config/settings.yml /etc/searxng/settings.yml
COPY searxng-custom/static/ /usr/local/searxng/searx/static/

# Mount the cloned theme files
RUN cp -r /tmp/theme-repo/out/crabx /usr/local/searxng/searx/templates/simple
RUN cp -r /tmp/theme-repo/out/crabx-static/themes/simple /usr/local/searxng/searx/static/themes/simple

RUN chown -R searxng:searxng /etc/searxng /usr/local/searxng
RUN rm -rf /tmp/theme-repo

EXPOSE 10000

CMD ["searxng"]
