FROM wordpress:php8.2-apache

RUN apt-get update \
 && apt-get install -y git libpq-dev \
 && docker-php-ext-install pgsql pdo_pgsql \
 && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/PostgreSQL-For-Wordpress/postgresql-for-wordpress.git /tmp/pg4wp \
 && cp -r /tmp/pg4wp/pg4wp /usr/src/wordpress/wp-content/pg4wp \
 && cp /tmp/pg4wp/pg4wp/db.php /usr/src/wordpress/wp-content/db.php \
 && rm -rf /tmp/pg4wp

COPY wp-config.php /usr/src/wordpress/wp-config.php
