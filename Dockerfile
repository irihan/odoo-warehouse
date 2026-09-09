FROM odoo:16.0

USER root

RUN apt-get update && apt-get install -y \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

USER odoo

EXPOSE 8069

CMD ["odoo", "-d", "odoo", "--db_port=5432"]