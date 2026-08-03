# `keepalived`

이 repository 는 keepalived 를 간단하게 설정할 수 있도록 docker container 로 만든 것이다.

## package

| key          | 설명                                       | version | 비고 |
|--------------|--------------------------------------------|:--------|------|
| keepalived   |                                            | 2.4.3   |      |
| gettext-base | env 사용으로 인한 설치                     |         |      |
| iproute2     | ip 관련 명령어 사용 - keepalived 에서 사용 |         |      |

## env

| key                       | 설명                |       default value       | required | 비고             |
|---------------------------|---------------------|:-------------------------:|:--------:|------------------|
| KEEPALIVED_STATE          | state               |          BACKUP           |    ✔︎    |                  |
| KEEPALIVED_INTERFACE      | 네트워크 인터페이스 |                           |    ✔︎    |                  |
| KEEPALIVED_ROUTER_ID      | Virtual Router ID   |             2             |          |                  |
| KEEPALIVED_PRIORITY       | 우선순위            | MASTER=200<br/>BACKUP=100 |          |                  |
| KEEPALIVED_UNICAST_SRC_IP | unicast source ip   |                           |    ✔︎    |                  |
| KEEPALIVED_UNICAST_PEERS  | unicase peer ips    |                           |    ✔︎    | 구분자 `,(콤마)` |
| KEEPALIVED_VIRTUAL_IP     | virtual ip          |                           |    ✔︎    |                  |

## Example (docker compose)

* 반드시, `network_mode` 를 `host` 로 해야 동작
    * linux 에서만 동작
* 반드시, `cap_add` 를 `NET_ADMIN` 으로 해야 동작
    * vip 를 host 에 추가해야됨

```yaml
name: db-ha

services:
  keepalived:
    image: ghcr.io/bob-park/keepalived
    network_mode: host
    cap_add:
      - NET_ADMIN
    environment:
      - KEEPALIVED_STATE=MASTER
      - KEEPALIVED_INTERFACE=1
      - KEEPALIVED_UNICAST_SRC_IP=192.168.0.11
      - KEEPALIVED_UNICAST_PEERS=192.168.0.12,192.168.0.13
      - KEEPALIVED_VIRTUAL_IP=192.168.0.10
```

## build

```bash
# keepalived version 을 version 으로 한다. 
KEEPALIVED_VERSION=v2.4.3 docker buildx bake -f docker-compose.yml --push --provenance false
```
