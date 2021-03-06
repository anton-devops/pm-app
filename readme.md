# тестовое задание на позицию DevOps

## Задание

Разработать CI на базе Github Actions.

Приложение написана на Go, а в качестве базы используется Postgres.
На POST-запрос по `/` приложение сохраняет текущее время в базу,
а на GET-запрос - возвращает список сохраненных значений.

Помимо самого приложения в проекте присутствует документация,
которая поставляется в виде статического сайта.
Файлы документации располагаются в директории `/docs`.

Процесс разработки можно разбить на три этапа:

- разработка
- CI
- локальный stage

### Разработка

Разработчики тестируют свое приложение.
Для тестирования нужна локальная база данных.
Тесты запускаются командой `go test` из директории `./app`.

- [ ] обеспечить разработчику удобный способ запуска контейнера с базой
- [ ] обратить внимание на скорость выполнения тестов

Разработчики вносят изменения в схему базы данных (`assets/schema.sql`),
а так же проверяют сборку образов на корректность и размер.

- [ ] предоставить инструкцию для сборки образа приложения и тестовых зависимостей
- [ ] обратить внимание на скорость сборки и размер итоговых образов

### CI

CI должен быть построен на базе Github Actions. 
На каждый коммит должны выполняется:

- [ ] статический анализ кода с помощью `golangci-lint`
- [ ] тесты

Релиз-пайплайн должен публиковать образы приложения и зависимостей в registry
(выбор registry на ваше усмотрение).

- [ ] пайплайн запускается по тегу на коммит (тег по semver)
- [ ] образы публикуются в registry и помечаются релизным тегом (app:v0.0.1)
  > окружение состоит из нескольких образов,
  > все публикуются с одинаковым тегом

### Локальный stage

Frontend-команда запускает проект локально, образы скачивают из registry

- [ ] команда для старта окружения должна начинаться с `docker-compose up --no-build`
- [ ] приложение должно быть доступно по адресу `http://localhost`,
  а документация - `http://docs.localhost`
  > документация построена на базе [mkdocs-material](https://squidfunk.github.io/mkdocs-material/)
  > и должна поставляться в собственном контейнере.
- [ ] должен быть удобный и быстрый способ переключиться на другую версию окружения (по тегам)
- [ ] данные в базе должны храниться перманентно

### Примечание

Вы можете обнаружить неточности в постановке задачи или ошибки в самом приложении
— не стесняйтесь задавать уточняющие вопросы.

Проект шуточный, но просим обратить внимание на скорость выполнения,
размер образов, безопасность и удобство использование.

Если вы пожелаете наполнить пайплайн дополнительными фичами
(контроль покрытия кода тестами, работа с git-ветками или дополнительный анализ),
то, несомненно, это будет плюсом.

Если вы не знаете как реализовать какое-то требование — измените условия под себя,
измените код программы, добейтесь чтобы оно работало.
Плохо сделанное задание в сто раз лучше, чем не сделанное.

## Справка

Запуск локальной версии документации:

```sh
cd docs
pip install -r requirements.txt
mkdocs serve
```

Сборка статического сайта с документацией:

```sh
mkdocs build
```

Скрипт инициализации базы находится в `assets/schema.sql`



#
--------------------------Выполненное задание ниже:----------------------------------------------------------------

## Инструкция по запуску

  1. клонируем репозиторий

          git clone https://github.com/anton-devops/pm-app.git

  2. заходим в папку .github (здесь находятся файлы, связанные только с пайплайном)

          cd pm-app/.github/

  3. создаём файл .env (содержимое можно создавать своим, если сфоркать в свой репозиторий, так же нужно создать секреты в своём репозитории для переменной POSTGRES_PASSWORD):
          
          echo "VER='v1.0.0'" >> .env
          echo "POSTGRES_USER='postgres'" >> .env
          echo "POSTGRES_HOST='db'" >> .env
          echo "POSTGRES_PASSWORD='postgres'" >> .env
          echo "POSTGRES_DB='postgres'" >> .env
          echo "IMAGE_URL='ghcr.io/anton-devops/pm-app'" >> .env
          echo "DOCKER_URL='ghcr.io'" >> .env

4. стартуем само приложение, базу и документацию коммандой:

        ./runner.sh v1.0.0

    где v1.0.0 версия релиза. Если не указать версию, то запустится дефолтная (v1.0.0)

5. проверяем:

    записываем текущую дату (согласно задания) в базу:

        curl -X POST http://localhost

    далее в браузере или через curl проверяем доступность сервисов:

        curl http://localhost       # должен вернуть дату, которую записали в базу коммандой выше
        curl http://docs.localhost  # возвращает страницу с документацией (см. задание)
