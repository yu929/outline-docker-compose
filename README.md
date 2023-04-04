# outline-docker-compose

## 修改内容
在原作者基础上修改如下：
- 使用keycloak所作为oidc，更适合公司内部使用，keycloak可以直接对接ldap
- nginx使用ssl，同时修改了部分配置
- 修改了时区

## 部署使用方式：
1. 进入项目目录，修改./scripts/config.properties文件
2. make install
3. admin进入keycloak：https://{HOST_NAME}/keycloak，创建第一步配置的realm，并切换到该realm
4. 在keycloak认证相关设置（具体设置方式参见keycloak官方文档）：
    - realm的ssl require改为None（不修改的话通过vpn等外部网络无法登录）
    - ldap同步，建议同步方式设为unsynced
    - client scops 添加 openid
    - 创建openid client，创建后获取clientid的secret
5. 修改项目目录下的env.oidc，填入clientid以及secret
6. make restart重启

## 注意事项
- docker compose文件中，镜像使用了公司私库地址，自行修改
- 第一次登录到outline，100%会超时或者502，这个估计是outline的问题。等2-3分钟，后台日志出现下面的日志，浏览器点后退，就自动进去了（此处必须要等出现这些日志再点后退，否则就会又再次触发初始化，导致有两个wiki）
    ```
outline-docker-compose-outline-1        | {"name":"users.create","modelId":null,"attempt":0,"label":"worker","level":"info","message":"Processing users.create"}
outline-docker-compose-outline-1        | {"templateName":"WelcomeEmail","props":{"to":"yanghuaiyu@haiyisec.com","teamUrl":"https://172.17.94.201"},"label":"worker","level":"info","message":"EmailTask running"}
outline-docker-compose-outline-1        | {"label":"email","level":"info","message":"Attempted to send email \"Welcome to Outline\" to yanghuaiyu@haiyisec.com but no transport configured."}
outline-docker-compose-outline-1        | {"name":"users.create","modelId":null,"label":"worker","level":"info","message":"AvatarProcessor running users.create"}
outline-docker-compose-outline-1        | {"name":"users.create","modelId":null,"label":"worker","level":"info","message":"WebhookProcessor running users.create"}
outline-docker-compose-outline-1        | {"name":"users.signin","modelId":null,"attempt":0,"label":"worker","level":"info","message":"Processing users.signin"}
outline-docker-compose-outline-1        | {"name":"users.signin","modelId":null,"label":"worker","level":"info","message":"WebhookProcessor running users.signin"}
    ```
- 项目默认使用ssl和443端口，需要调整的自行修改