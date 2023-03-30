# The url used to vist this web site.
URL=https://wiki.haiyisec.com
# The default interface language. See translate.getoutline.com for a list of
# available language codes and their rough percentage translated.
DEFAULT_LANGUAGE=zh_CN
FORCE_HTTPS=false

# Docker image version
POSTGRES_VERSION=15.2
KEYCLOAK_VERSION=21.0.1
MINIO_VERSION=RELEASE.2023-03-24T21-41-23Z
MINIO_MC_VERSION=RELEASE.2023-03-23T20-03-04Z

# Nginx
# The nginx bind ip and port.
# If you use ip address to access outline, this ip and port should be same as the URL.
# If this server behind a proxy(nginx), you can bind to `127.0.0.1`.
HTTP_IP=127.0.0.1

# Docker
# If you server behind a proxy(nginx), and the proxy created by docker. You can use the proxy's network. Set the `NETWORKS` to proxy's network name, and set `NETWORKS_EXTERNAL` to `true` .
# The sample config for host nginx can be find in `config/sample/nginx_outline.conf`.
NETWORKS=outlinewiki
NETWORKS_EXTERNAL=false

# Secret keys, update by script.
# You shouldn't edit it.
MINIO_ACCESS_KEY=
MINIO_SECRET_KEY=
OUTLINE_SECRET_KEY=
OUTLINE_UTILS_SECRET=
