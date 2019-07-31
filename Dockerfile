# To build the Docker image:
#
#   $ sudo systemctl start docker
#   $ sudo docker build -t printer .
#
# To run it:
#
#   $ sudo docker run -d -p 9393:9393 -t printer
#
# To push to repository:
#
#   $ sudo docker login
#   $ sudo docker tag printer docker.io/strzibnyj/invoice_printer_server:latest
#   $ sudo docker push strzibnyj/invoice_printer_server:latest
FROM alpine:3.10
MAINTAINER Josef Strzibny <strzibny@strzibny.name>

ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

# Update system
RUN apk update &&  apk upgrade

# Install Ruby and build dependencies
RUN apk add build-base bash ruby ruby-etc ruby-dev

# Install to have DejaVu fonts available
RUN gem install dejavu-fonts --no-document

# Install gem from RubyGems.org
RUN gem install invoice_printer_server --version 2.0.0.beta2 --no-document

# Clean APK cache
RUN rm -rf /var/cache/apk/*

# Run the server on port 80
ENTRYPOINT ["/usr/local/bundle/bin/invoice_printer_server", "-p9393"]
