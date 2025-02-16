<h1 align="center">
	:dvd: Задание 3: docker
</h1>


### Для начала соберём дефолтный docker compose, в котором будут дефолтные настройки (чисто проверить образы)

```yml
services:
  nginx: 
    image: nginx:1.25
    ports:
      - 80:80
  php:
    image: php:7.4-fpm
```
---

### Затем подружим наш nginx и php.

Для начала нам нужно смонтировать файл default.conf, чтобы было проще настраивать файл

- Первой командой залезем в nginx, 
```bash
docker compose exec nginx bash
```
- второй дотягиваемся до _default.conf_, 
```bash
cat /etc/nginx/conf.d/default.conf
```
- настройки этого конфига копируем себе в проект
- и монтируем наш конфиг файл в nginx:
---

### Промежуточный код выглядит следующим образом
```yml
services:
  nginx: 
    image: nginx:1.25
    ports:
      - 80:80
    volumes:
      - './src:/var/www/html'
      - './docker/nginx/conf.d:/etc/nginx/conf.d'
  php:
    image: php:7.4-fpm
    volumes:
      - './src:/var/www/html'
```
---

### Далее отредактируем default.conf, чтобы убедиться в правильности действий:

```bash
    location ~ \.php$ {
        root           var/www/html;
        fastcgi_pass   php:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
```

После чего в браузере пропишем _http://localhost/index.php_ и увидим версию php.
---

### Также необходимо поменять внешний порт на контейнере nginx 

Для этого нужно отредактировать 2 файла:
- docker слушает порт [00]:00, а отправляет на порт 00:[00], соответственно в _docker-compose.yaml_ мы меняем порт после двоеточий:

```yaml
    ports:
      - 80:1234
```

- а в _default.conf_ меняем "listen", меняем порт в двух значениях, так как один слушает IPv4, второй - IPv6
```
    listen       1234;
    listen  [::]:1234;
    server_name  localhost;
```
---

### У контейнера PHP переменную окружения PHP_FPM_LISTEN установить 0.0.0.0:9000 и смонтировать текущий каталог в каталог /var/local/sandboxes/dev/www

- переменную окружения и монтирование папки прописываем в _docker-compose.yaml_

```yaml
  php:
    image: php:7.4-fpm
    volumes:
      - './src:/var/www/html'
      - '.:/var/local/sandboxes/dev/www'
    environment:
      - HP_FPM_LISTEN=0.0.0.0:9000
```
---

### ### Контейнеры должны общаться в своей собственной сети "vita"

Cоздадим сеть с названием vita в этом же файле docker-compose и в каждом контейнере укажем созданную сеть:

```yaml
networks:
  vita:
    driver: bridge
```
---

### Написать команду запуска docker compose

```bash
docker-compose up -d
```

Если нужны логи контейнеров в реальном времени, просто выполните команду без флага -d:

```bash
docker-compose up
```

Для остановки и удаления всех контейнеров, созданных с помощью docker-compose up, используйте команду:

```bash
docker-compose down
```
---

### Если файл default.conf в системе поменяется, изменится ли он внутри контейнера тоже? Нужен рестарт при изменение файла default.conf? А если в docker-compose внесли изменения?

- Файл default.conf можно менять внутри контейнера только в одном случае - когда файл или папка с файлом смонтированы в контейнер при помощи _volumes_. 

- Чтобы изменения вступили в силу - необходимо перезапустить контейнер:

```bash
docker-compose restart <имя_сервиса>
```

- В случае изменения docker-compose необходимо также перезагрузка, но уже другой командой:

```bash
docker-compose up -d
```
---

### Docker Compose vs. Docker Swarm
Что касается предпочтений между Docker Compose и Docker Swarm, это зависит от потребностей:

- Docker Compose: Лучше подходит для разработки и тестирования локальных приложений. 

- Docker Swarm: Предназначен для управления кластером Docker-узлов и обеспечивает оркестрацию контейнеров (как Kubernetes). 