FROM python:2-slim

RUN apt-get update; \
    apt-get install -qq -y --no-install-recommends \
      wkhtmltopdf \
      node-less \
      fonts-noto-cjk \
      virtualenv \
      build-essential \
      postgresql-common \
      libsasl2-dev libldap2-dev libssl-dev libpq-dev libjpeg-dev zlib1g-dev libxml2-dev libxslt-dev \
      python-watchdog

# Mount /var/lib/odoo to allow restoring filestore
VOLUME ["/var/lib/odoo"]

# Create the odoo user
RUN useradd --create-home --home-dir /opt/odoo --no-log-init odoo
USER odoo
WORKDIR /opt/odoo
ENV PATH="opt/odoo/.local/bin:${PATH}"

RUN virtualenv venv
RUN . venv/bin/activate \
 && pip install --upgrade pip \
 && pip install --upgrade setuptools \
 && pip install http://nightly.odoo.com/10.0/nightly/src/odoo_10.0.latest.tar.gz \
 && pip install odoo-autodiscover \
 && pip install --pre odoo10-addons-oca-l10n-italy

EXPOSE 8069 8071
CMD . venv/bin/activate \
 && odoo --db_host db -r odoo -w odoo
