# Use official PHP 8.2 with Apache as the base image
FROM php:8.2-apache

# Install system dependencies required by Laravel & PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    curl \
    iputils-ping \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql zip


# Install Composer globally
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# Use below line instead of above command to avoid downloading during build
# Copy Composer from official composer image (multi-stage build)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Enable Apache mod_rewrite (needed for Laravel pretty URLs)
RUN a2enmod rewrite

# Set working directory inside the container
WORKDIR /var/www/html


# Set correct Apache document root to Laravel’s public folder
# (Default is /var/www/html, but we point to /var/www/html/public)
ENV APACHE_DOCUMENT_ROOT /var/www/html/public


# Update Apache config to use new document root
# Replace "/var/www/html" with the value of the APACHE_DOCUMENT_ROOT environment variable in all relevant config files
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Expose port 80 (Apache HTTP)
EXPOSE 80

# Start Apache when container runs
CMD ["apache2-foreground"]