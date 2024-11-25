# crowd


New Crowd releases support only Data Center licenses. To generate a Data Center licenses, add the `-d` parameter.

---

default port: 8095

+ Latest Version(arm64&amd64): v6(6.1.2)


## Requirement
- docker-compose: 17.09.0+

## How to run with docker-compose

- start crowd & mysql

```
git clone https://github.com/danoooob/crowd.git \
    && cd crowd \
    && docker-compose up
```

- start crowd & mysql daemon

```
docker-compose up -d
```

- default db(mysql8.0) configure:

```bash
driver=mysql
host=mysql-crowd
port=3306
db=crowd
user=root
passwd=123456
```

## How to run with docker

- start crowd

```
docker volume create crowd_home_data && docker network create crowd-network && docker run -p 8095:8095 -v crowd_home_data:/var/crowd --network crowd-network --name crowd-srv -e TZ='Asia/Shanghai' danoooob/crowd:6.1.2
```

- config your own db:


## How to hack crowd

```
docker exec crowd-srv java -jar /var/agent/atlassian-agent.jar \
    -d \
    -p crowd \
    -m Hello@world.com \
    -n Hello@world.com \
    -o your-org \
    -s you-server-id-xxxx
```

## How to upgrade

```shell
cd crowd && git pull
docker pull danoooob/crowd:latest && docker-compose stop
docker-compose rm
```

enter `y`, then start server

```shell
docker-compose up -d
```