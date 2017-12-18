## Homework 05

Хост bastion:
- IP: 35.205.90.196
- внутр. IP: 10.132.0.2

Хост: someinternalhost:
- внутр. IP: 10.132.0.3

### Подключение по ssh одной командой

Для того чтобы подключиться к internalhost одной командой нужно воспользоваться следующей командой:

```bash
ssh -J appuser@35.205.90.196 appuser@10.132.0.3
```

если версия ssh не поддерживает передыдущую команду, то воспользоваться следующей:

```bash
ssh -o ProxyCommand='ssh -W %h:%p appuser@35.205.90.196' appuser@10.132.0.3
```
### Дополнительное задание

Для того чтобы можно было подключаться к хосту, который находится за бастион хостом, по имени(например internalhost) нужно использовать следующую конфигурацию для ssh

```bash
Host internalhost
    HostName 10.132.0.3
    ProxyJump appuser@35.205.90.196:22
    User appuser
```

Где

- HostName - имя хоста, к которому хотим подключиться или его ip
- ProxyJump - параметры подключения к бастион хосту
- User - имя пользователя, от которого подключаться

Для более старых версий ssh использовать конфигурацию:

```bash
Host bastion
  Hostname 35.205.90.196
  User appuser

Host internalhost
  Hostname 10.132.0.3
  ProxyCommand ssh -i ~/.ssh/appuser bastion -W %h:%p
  User appuser
```
## Homework 06

Добавлены скрипты для установки ruby и mongodb

Добавлен скрипт для развертывания приложения вручную, а так же скрипт для автоматической установки приложения во время создания виртуальной машины.

Для того чтобы при запуске виртульной машины выполнить свой скрипт необходимо добавить опцию ```--metadata-from-file startup-script=startup_script.sh```

Целиком команда будет выглядеть так:

```bash
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --zone=europe-west1-c \
  --metadata-from-file startup-script=startup_script.sh
```

Для создания правила файрвола можно воспользоваться командой:

```bash
gcloud compute --project=infra-188914 firewall-rules\
  create default-puma-server\
  --direction=INGRESS\
  --priority=1000\
  --network=default\
  --action=ALLOW\
  --rules=tcp:9292\
  --source-ranges=0.0.0.0/0\
  --target-tags=puma-server
```
