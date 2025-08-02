## Description
Скрипт для поиска секретов в репозиториях Gitlab.

Поиск происходит по истории всех комитов в репозитории c помощью утилиты gitleaks.

Для поиска используются паттерны gitleaks по умолчанию + кастомные правила которые задаются в конфигурационном файле `gitleaks.toml`

Более подробно о утилите тут - https://github.com/gitleaks/gitleaks

По завершению поиска создается архив `search.zip` который содержит два файла с отчетами и отправляется на указаную почту

## Configuration
Для настройки правил нужно редактировать `gitleaks.toml`

По умолчанию используются правила описанные тут https://github.com/gitleaks/gitleaks/blob/master/config/gitleaks.toml

Также используется кастомные правила, например для поиска серии и номера паспорта в формате dddd|dddddd
```
[[rules]]
id = "passport"
description = "serial number"
regex = '''\d{4}\|\d{6}'''
tags = ["pd"]
```
Чтобы добавить новое правило, его нужно описать в таком формате
```
[[rules]]
id = "id имя (может быть любое)"
description = "короткое описание"
regex = '''Регулярное выражение'''
tags = ["pd"]
```
Также для исключения из отчета не нужных результатов используется конфиг `exclusion.rules`
Как работает исключение: если результат поиска содержит строку из файла exclusion.rules, то эта строка будет удалена из отчёта.
Чтобы добавить исключение - в файле exclusion.rules добавить новую строку с текстом по которому будет исключение.
Новые правила будут автоматически добавлены в сл.поиск по расписанию

В файле `main.py` в списке `exclusion_list` можно указывать id репозиториев в которых не нужно выполнять поиск
## Build
Сборка контейнера запускается по изменениям файлах `main.py` или `Dockerfile`
## Deploy
Деплоится cronjob в кластер k8s.
Запуск происходит один раз в неделю во вторник ночью.
## Results
После выполнения cronjob на почту приходит архив с файлами `pd_report.xlsx, g_report.xlsx`
Отчет содержит имя репозитория, данные о коммите и авторе и найденую строку.

Пример
| Repository | Commit | Commit Date | Author | Path | Matched Line | Full String |  
| ------ | ------ | ------ | ------ | ------ | ------ | ------ | 
| app-service | 48d8e3ad277ff1a114d863acff3f240d98ab2f20 | 2021-05-26T16:37:13Z | gitalab-user | https://gitlab.example.com/mycomp/app-service/-/blob/48d8e3ad277ff1a114d863acff3f240d98ab2f20/src/main/resources/application.properties | PASSWORD=xxxxxAz3Daxxxx |PASSWORD=xxxxxAz3Daxxxx |
## ToDo
Внедрить в поиск проверку с помощью https://github.com/Privado-Inc/privado 
