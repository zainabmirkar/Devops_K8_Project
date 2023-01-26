FROM centos:latest
MAINTAINER vikashashoke@gmail.com

# Install necessary packages
RUN yum update -y && \
    yum install -y httpd && \
    yum clean all

# Create a non-root user
RUN useradd -r -u 1000 -g 0 myuser

# Copy website files
COPY photogenic.zip /tmp/

# Unzip files and move to web root
RUN set -ex && \
    unzip /tmp/photogenic.zip -d /var/www/html/ && \
    chown -R myuser:0 /var/www/html/photogenic && \
    rm -rf /tmp/photogenic.zip

# Update the Document root
ENV APACHE_DOCUMENT_ROOT /var/www/html/photogenic
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/httpd/conf/httpd.conf

# Switch to non-root user
USER myuser

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
