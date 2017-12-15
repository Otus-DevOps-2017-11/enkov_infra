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
