# jekyll-nginx-18-centos7
FROM centos/nginx-18-centos7

MAINTAINER Josh Preston <the@mrjoshuap.com>

ENV BUILDER_VERSION 1.0

# Become the root user
USER 0

# Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for Jekyll based web sites" \
      io.k8s.display-name="jekyll 3.3.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="jekyll,3.3.0,nginx-18,centos"

# Defines the location of the S2I
LABEL io.openshift.s2i.scripts-url=image:///usr/local/s2i

# Copy the S2I scripts from ./.s2i/bin/ to /usr/local/s2i when making the builder image
COPY ./.s2i/bin/ /usr/local/s2i

# Install required packages here:
RUN yum install -y \
      rh-ruby22 \
      rh-ruby22-ruby-devel \
      rh-ruby22-rubygem-bundler \
    && yum clean all -y

# Install the required gems
RUN source scl_source enable rh-ruby22 && gem install jekyll

# Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# Set the default port for applications built using this image
EXPOSE 8080

# Set the default CMD for the image
CMD ["usage"]
