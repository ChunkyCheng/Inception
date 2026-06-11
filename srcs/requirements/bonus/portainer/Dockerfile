FROM alpine:3.23

RUN apk add --no-cache wget

RUN wget -q "https://github.com/portainer/portainer/releases/download/2.21.0/portainer-2.21.0-linux-amd64.tar.gz" \
    -O /tmp/portainer.tar.gz && \
    tar -xzf /tmp/portainer.tar.gz -C /opt/ && \
    rm /tmp/portainer.tar.gz

CMD [\
	"/opt/portainer/portainer", \
	"--admin-password-file", \
	"/run/secrets/portainer_password"]
