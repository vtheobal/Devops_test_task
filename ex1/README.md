<h1 align="center">
	:sassy_man: Задание 1: ansible
</h1>

### Приступим к выполнению задания

1. Для начала создадим рабочую папку, в которой у нас лежит проект

```
$ mkdir project 
```
---

2. Затем создаём hosts.ini файл, в которм записываем группу серверов

```
$ cat > hosts.ini 

[server] 
target1 ansible_host=192.168.31.44 ansible_connection=ssh ansible_user=root ansible_ssh_pass=osboxes.org  

target2 ansible_host=192.168.31.133 ansible_connection=ssh ansible_user=root ansible_ssh_pass=osboxes.org 
```
---

3. После делаем тестовое соединение чтобы проверить соединение с серверами.

	P.S. Важно изначально сделать рукопожатие по ssh с целевыми серверами, иначем команда ниже выдаст ошибку.

```
$ ansible server -m ping -i hosts.ini 
```

3.1. Прежде чем приступить к создания целевог _playbook-copy.yml_, я решил создать _playbook-ping.yml_ (в этом не было необходимости, я создал его для себя, чтобы проверять конект с целевыми серверами)

```yaml
-
  name: тест соединения с целевыми серверами
  hosts: server
  tasks:
    - name: Ping test
      ping:

```
---

4. После после создания host.ini приступаем к создания _playbook-copy.yml_ который копирует файл с основного сервера на целевой:

```yaml
- name: Копирование локальных файлов на сервер

  hosts: server
  tasks:
    - name: Создание папки на удаленном сервере
      file:
        path: /home/osboxes/ex1/test-folders  # Путь к создаваемой папке
        state: directory

    - name: Копирование файла на удалённый сервер
      copy:
        src: /home/osboxes/ex1/test-folders/file.txt  # Путь к локальному файлу
        dest: /home/osboxes/ex1/test-folders/file.txt  # Путь на удалённом сервере
```
---

5. Playbook из бункта 4 отрабатывает коректно, но нам небходимо кортеж _tasks_ обернуть в Role: для начала создадим структуру каталогов для роли:

```
mkdir -p roles/copy_files/{tasks,handlers,defaults,vars,meta}
```
---

6. Затем в папке tasks создадим main.yml, в который положим  картеж _tasks_ из _playbook-copy.yml_

```yaml
- name: Создание папки на удаленном сервере
  file:
    path: /home/osboxes/project/test-folders
    state: directory

- name: Копирование файла на удалённый сервер
  copy:
    src: /home/osboxes/project/test-folders/file.txt
    dest: /home/osboxes/project/test-folders/file.txt

```
---

7. После чего отредактируем _playbook-copy.yml_, заменив картеж _tasks_ на вызов роли _copy_files_

```yaml
- name: Копирование локальных файлов на сервер
  hosts: server
  #become: yes  # Используйте, если необходимо повысить привилегии
  roles:
    - copy_files
```
---

8. Готово. Мы имеем playbook-copy.yml, который через роль _copy_files_ копирует файл с основного сервера на целевой.

Для выполнения этого задания потребовалось развернуть 3 сервера: один основной и 2 целевых. Во время технического собвеседования все сервера ит работа кода будет продемонстрирована.