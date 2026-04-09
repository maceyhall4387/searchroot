FROM docker.io/searxng/searxng:latest

# Download and extract the theme repo using Python
RUN python3 << 'EOF'
import urllib.request
import zipfile
import os

url = 'https://codeload.github.com/cra88y/simply-nord/zip/refs/heads/main'
urllib.request.urlretrieve(url, '/tmp/theme.zip')
zipfile.ZipFile('/tmp/theme.zip').extractall('/tmp')
os.rename('/tmp/simply-nord-main', '/tmp/theme-repo')
EOF

COPY searxng-custom/core-config/settings.yml /etc/searxng/settings.yml
COPY searxng-custom/static/ /usr/local/searxng/searx/static/

# Mount the cloned theme files - matching the volume paths from the readme
RUN cp -r /tmp/theme-repo/out/crabx /usr/local/searxng/searx/templates/simple
RUN cp -r /tmp/theme-repo/out/crabx-static /usr/local/searxng/searx/static/themes/simple

RUN chown -R searxng:searxng /etc/searxng /usr/local/searxng
RUN rm -rf /tmp/theme-repo /tmp/theme.zip

EXPOSE 10000

CMD ["searxng"]
