docker-compose := $(shell command -v docker-compose 2> /dev/null || echo "docker compose")

gen-conf:
#	echo ${docker-compose}
	cd ./scripts && bash ./main.sh init_cfg

start:
	${docker-compose} up -d
	cd ./scripts && bash ./main.sh reload_nginx

install: gen-conf start

restart: stop start

logs:
	${docker-compose} logs -f

stop:
	${docker-compose} down || true

update-images:
	${docker-compose} pull

clean-docker: stop
	${docker-compose} rm -fsv || true

clean-conf:
	rm -rfv env.* .env docker-compose.yml

clean-data: clean-docker
	rm -rfv ./data/certs ./data/minio_root ./data/pgdata

clean: clean-docker clean-conf
