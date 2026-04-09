FROM docker.io/searxng/searxng:latest

# Download and extract the theme repo using Python
RUN python3 << 'EOF'
import urllib.request
import zipfile
import os

urllib.request.urlretrieve('https://github.com/simply-nord/simply-nord/archive/refs/heads/main.zip', '/tmp/theme.zip')
zipfile.ZipFile('/tmp/theme.zip').extractall('/tmp')
os.rename('/tmp/simply-nord-main', '/tmp/theme-repo')
EOF

COPY searxng-custom/core-config/settings.yml /etc/searxng/settings.yml
COPY searxng-custom/static/ /usr/local/searxng/searx/static/

# Mount the cloned theme files
RUN cp -r /tmp/theme-repo/out/crabx /usr/local/searxng/searx/templates/simple
RUN cp -r /tmp/theme-repo/out/crabx-static/themes/simple /usr/local/searxng/searx/static/themes/simple

RUN chown -R searxng:searxng /etc/searxng /usr/local/searxng
RUN rm -rf /tmp/theme-repo /tmp/theme.zip

EXPOSE 8080

CMD ["searxng"]
