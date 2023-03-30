#!/bin/bash
# Generate config and secrets required to host your own outline server
. ./config.sh
. ./utils.sh

# update config file
MINIO_ACCESS_KEY=${MINIO_ACCESS_KEY:-`openssl rand -hex 8`}
MINIO_SECRET_KEY=${MINIO_SECRET_KEY:-`openssl rand -hex 32`}
OUTLINE_SECRET_KEY=${OUTLINE_SECRET_KEY:-`openssl rand -hex 32`}
OUTLINE_UTILS_SECRET=${OUTLINE_UTILS_SECRET:-`openssl rand -hex 32`}

function update_config_file {
    env_replace MINIO_ACCESS_KEY $MINIO_ACCESS_KEY config.sh
    env_replace MINIO_SECRET_KEY $MINIO_SECRET_KEY config.sh
    env_replace OUTLINE_SECRET_KEY $OUTLINE_SECRET_KEY config.sh
    env_replace OUTLINE_UTILS_SECRET $OUTLINE_UTILS_SECRET config.sh
}

function create_global_env_file {
    fn=.env
    env_file=../$fn
    cp ./templates/$fn $env_file
    env_replace NETWORKS $NETWORKS $env_file
    env_replace NETWORKS_EXTERNAL $NETWORKS_EXTERNAL $env_file
    # NGINX
    env_replace HTTP_IP $HTTP_IP $env_file
    # Docker image version
    env_replace POSTGRES_VERSION $POSTGRES_VERSION $env_file
    env_replace KEYCLOAK_VERSION $KEYCLOAK_VERSION $env_file
    env_replace MINIO_VERSION $MINIO_VERSION $env_file
    env_replace MINIO_MC_VERSION $MINIO_MC_VERSION $env_file
}

function create_minio_env_file {
    fn=env.minio
    env_file=../$fn
    cp ./templates/$fn $env_file
    env_replace MINIO_ACCESS_KEY $MINIO_ACCESS_KEY $env_file
    env_replace MINIO_SECRET_KEY $MINIO_SECRET_KEY $env_file
}

function create_outline_env_file {
    fn=env.outline
    env_file=../$fn
    cp ./templates/$fn $env_file

    env_replace URL $URL $env_file
    env_replace SECRET_KEY $OUTLINE_SECRET_KEY $env_file
    env_replace UTILS_SECRET $OUTLINE_UTILS_SECRET $env_file
    env_replace DEFAULT_LANGUAGE $DEFAULT_LANGUAGE $env_file
    env_replace FORCE_HTTPS $FORCE_HTTPS $env_file

    env_delete DATABASE_URL $env_file
    env_delete DATABASE_URL_TEST $env_file
    env_delete REDIS_URL $env_file
    env_delete AWS_S3_UPLOAD_BUCKET_NAME $env_file

    env_delete SLACK_KEY $env_file
    env_delete SLACK_SECRET $env_file
    env_delete SLACK_APP_ID $env_file
    env_delete SLACK_KEY $env_file
    env_replace SLACK_MESSAGE_ACTIONS false $env_file

    env_replace AWS_ACCESS_KEY_ID $MINIO_ACCESS_KEY $env_file
    env_replace AWS_SECRET_ACCESS_KEY $MINIO_SECRET_KEY $env_file
    env_replace AWS_S3_UPLOAD_BUCKET_URL $URL $env_file

    env_add PGSSLMODE disable $env_file

    fn=env.oidc
    env_file=../$fn
    cp ./templates/$fn $env_file
}

function create_env_files {
    create_global_env_file
    create_minio_env_file
    create_outline_env_file
}

function create_docker_compose_file {
    fn=docker-compose.yml
    file=../$fn
    cp ./templates/$fn $file

    env_tmpl_replace NETWORKS "$NETWORKS" $file
    env_tmpl_replace MINIO_ACCESS_KEY "$MINIO_ACCESS_KEY" $file
    env_tmpl_replace MINIO_SECRET_KEY "$MINIO_SECRET_KEY" $file
}

function init_cfg {
    update_config_file
    create_docker_compose_file
    create_env_files
}

function reload_nginx {
    cd ..;
    until docker-compose exec nginx nginx -s reload
    do
        echo "waiting nginx"
        sleep 1
    done
}

$*
