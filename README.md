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

### HOMEWORK 07

Создан конфиг для packer для создания образа в GCP.
Так же выполнены дополнительные задания

Все переменные вынесены в variables.json файл

```bash
{
  "project_id": "project-1234",
  "source_image_family": "ubuntu",
  "machine_type": "f1-micro"
}
```
Для запуска ВМ в GCP использовалась следующая команда:
```bash
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family reddit-full \
  --image-project=infra-188914 \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --zone=europe-west1-c
```

## Homework 08

Задание со звездочкой 1
Для добавления ssh ключей в проект нужно воспользоваться ресурсом ```google_compute_project_metadata```

В нем нужно указать

```bash
metadata {
  ssh-keys = "appuser1:${file("${var.public_key_path}")}appuser2:${file("${var.public_key_path}")}"
  }
```

После добавления ключа appuser_web через веб интерфейсе и применения команды terraform apply ключ appuser_web удаляется, т.к. он не был описан в terraform.

Так же удаляются ранее добавленные ключи.

Задание со звездочкой 2

Для создания балансировщика в GCP нужно создать следующие ресурсы:

- google_compute_instance_group - группа инстансов, на которые нужно балансировать
- google_compute_http_health_check - проверка работоспосибности инстансов
- google_compute_backend_service - группа ВМ, которые будут обслужить трафик для балансировщика
- google_compute_url_map - определяет на какой истанс отправить запрос в зависимости от url
- google_compute_target_http_proxy
- google_compute_global_forwarding_rule


## Homework 09

Задание со звездочкой 1

Для того чтобы использовать remote state в gcp нужно сначала создать бакет с помощью команды

```bash
gsutil mb gs://enkov-terraform-state
```

И прописать настройки в terraform

```bash
terraform {
  backend "gcs" {
    bucket = "example"
    prefix   = "example/terraform.tfstate"
  }
}
```

Задание со звездочкой 2

Для того чтобы при деплое сразу развертывалось и приложение было сделано следующее:

Добавлен шаблон для запуска приложения, в который подставляется переменная окружения с адресом базы данных

```bash
data "template_file" "puma_service" {
  template = "${file("../modules/app/templates/puma.service.tpl")}"

  vars {
    db_address = "${module.db.internal_ip}"
  }
}

```

В провиженинге базы меняется файл настроек для того чтобы mongo слушала на всех адресах, а не только на 127.0.0.1, т.к. база данных теперь в отдельной ВМ.

```bash
provisioner "remote-exec" {
  inline = [
    "sudo sed -i 's/bindIp: .*/bindIp: 0.0.0.0/' /etc/mongod.conf",
    "sudo systemctl restart mongod",
  ]
}
```
