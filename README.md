BSUIR Courses
=============

# Домашка 1

Необходимо написать некоторое подобие утилиты `sl`. Для того чтобы иметь представление что делает данная утилита, для ubuntu можно поставить ее через `sudo apt-get install sl` и после завершения установки написать в терминале `sl`. Если вы упали со стула потому что на вас поехал паровоз - вы на правильном пути.

В данном домашнем задании мы не ограничиваем вас только поездом, в общем случае это должна быть какая-то ASCII-картинка которая будет как-то дергаться.

# Домашка 2.1

Необходимо написать утилиту `gemfiler`, которая будет показывать отфильтрованные версии гемов. 

Входные параметры: 
* Имя gem'а
* Указание версий в формате, совместимом с Gemfile

Вывод на консоль:
* Все версии данной библиотеки, при этом красным цветом подсвечиваются отфильтрованные версии.

Требования:
* Утилита должна парсить входные параметры с использованием существующих библиотек.
* Все версии gem'ов должны браться путем парсинга страницы или через взаимодействите с rubygems API
* Утилита должна быть поделена на независимые модули, каждый должен быть представлен отдельным классом.
* Правильная обработка потока ошибок.

Примеры:
```
./gemfiler devise '~> 2.1.3'
./gemfiler rails '>= 3.1'
./gemfiler rails '>= 3.1' '< 4.0'
```

# Домашка 2.2

Создаем убийцу `grep`. Для тех кто не знает что это такое - советую пойти поиграться в консоль с этой утилитой. Если кратко - то это утилита для поиска строк, содержащих текст в файлах. Атомарной единицей для этой утилиты является строка. То есть при поиске если вы находите в строке искомый текст - она выдает вам обратно в STDOUT строку.

Если вы зайдете в мануал то увидите что формат команды примерно такой:

```
	grep [options] PATTERN [FILE...]
	grep [options] [-e PATTERN | -f FILE] [FILE...]
```

Первый формат означает что в команду сперва передаются опции, затем какой-то текст для поиска в файле и затем 1 или несколько файлов. Второй формат примерное такой же, но использует регулярные выражения для поиска по файлам.

## Требования

В результате домашнего задания вам нужно написать утилиту grep с несколько ограниченным функционалом. 
Необходимые опции которые вам надо реализовать:

* `-A` - опция которая выводит количество строк до и после найденной строки
* `-e` - опция которая позволяет вводить регулярные выражения вместо просто части строки
* `-R` - опция которая говорит искать строку не в одном файле, а рекурсивно во всех файлах в папке
* `-z` - опция указывающая что файлик является сжатым и сначала его надо разжать и только потом искать по нему. 
 
## Немного примеров

Для примера будем использовать файлик 1.txt со следующим содержанием:

```
aa
bb
cc
abc
bcd
cde
ggg
```

Результаты выполнения:

```
grep a 1.txt 
=> aa
=> abc
```


```
grep -A 1 ab 1.txt 
=> cc
=> abc
=> bcd
```

```
grep -A 1 b 1.txt 
=> aa
=> bb
=> cc
=> cc
=> abc
=> bcd
=> abc
=> bcd
=> cde
```


```
grep -e "a[^b]" 1.txt 
=> aa
```

## Этапы

Для того чтобы вы сразу не писали огромную утилиту разобьем ее имплементацию на несколько этапов:

* Сделайте утилиту которая просто без опций находит строки в файле.
* Добавьте возможность искать по нескольким файлам, aka `grep a 1.txt 2.txt`
* Добавьте опцию `-A` которая выводит соседние строки.
* Добавьте опцию `-e` которая ищет по регуляркам
* Добавьте опцию `-R` которая будет искать по всем файлам в папке
* Добавьте опцию `-z` которая будет искать по сжатому через gzip файлу


## Проверка

Задания принимаются __только__ ввиде ссылки на гитхаб.

# Домашка 3

Необходимо написать консольное приложение, которое позволяет посмотреть отзывы о преподователях БГУИР в этом семестре по номеру учебной группы. Выводить отзывы на преподавателей разными цветами, в зависимости от настроения отзыва. Хороший - зеленым цветом, плохой - красными цветом, нейтральный - белым. Настроение отзыва определять по ключевым словам, которые загружаются из YAML файла `keywords.yml` в корне программы.
Список преподавателей для конкретной группы необходимо получать с сайта `http://www.bsuir.by/schedule/schedule.xhtml`. Отзывы о преподавателях брать с сайта `http://bsuir-helper.ru/`. 

## Пример работы программы
```ruby
./bsuir-reviews 250501

Третьяков А. Г.
=====
Не найдено отзывов

Смирнов И. В.
=====
01/12/2014 - 17:49: Вёл ЭПр. Впринципе мужык довольно неплохой, хоть и странноватый немного. Автоматы ставит от 7-ми баллов, на экзамене для сдачи надо написать 2 вопроса и желательно решить задачу, хотябы в общем виде, чтобы небыло проблем. Дополнительные вопросы обычно задаёт по билету. Оценка на экзамене зависит от рекомендованой, если ответил хорошо - это + 1 балл к заходной. Сложность списывания зависит от того, когда сдаётся экзамен, если в начале сессии то вполне можно спалится, если уж слишком явно это делать, а в конце или тем более на пересдаче никаких проблем, пересдач обычно очень мало, да и если уже будет, сдать потом не особо проблематично.

Самаль Д. И.
=====
06/07/2014 - 23:38: Отличный преподаватель и замечательный человек ! Заменял у нас лекции по дисциплине "Алгоритмы компьютерной графики"(ПОИТ,2 курс). Отлично рассказывает материал не оторваны от реальности,с красочными примера и пояснениями. У него работает система бонусов - за ответы на лекциях и активное участие, как для нормальных студентов, так и для "галерки" :) В конце семестра подводит процентовку успеваемости, по итогам которой относит нашего брата к той или иной категории : 1)Automat 2)Зачет Light 3)Зачет Hard 4)Dead :D P.S.Помимо этого рассказал очень полезную информацию, касающуюся не только учебы , а жизни в целом ;)

10/12/2012 - 15:50: Самаль оставил после себя очень хорошее впечатление, МГ и СИФО предметы не из легких конечно, и требовал он чтобы все работало и правильно, 4 раза до 30 декабря одну лабу носили, ну не могли сделать правильно, но злости после себя не оставляет. Начинать собирать курсач из кусков реально лучше хотя бы за недели 3, тогда из кусков + готовых можно легко склепать нормальный вариант. По курсачу треть где-то тоже не успела сдать до сессии. По СИФО лучше стараться вытащить на контрольных автомат хотя бы 4, автоматов будет большинство. Если на экзамене не можешь ответить - только в следующий раз, прошарившись; билет тот же.
```

## Формат файла с ключевыми словами

```yml
negative:
  - плохой
  - скучный

positive:
  - хороший
  - мировой
  - великолепный
```

##  Требования
* Для парсинга обоих сайтов использовать гем `mechanize`. 
* Для вывода текста цветом использовать гем `colorize`
* Слова грузить из YAML файла, следуя формату выше
* Обязательно разбить все на разные классы
* Иметь опцию '-h', которая выводит подсказку для использования программы. Также выводить ее если не передано никаких аргументов в программу
* Иметь `Gemfile`, в котором будет список всех использованных вами гемов
* Предусмотреть ситуации когда у вас не будет интернета и утилита не заработает (обработка ошибок)

## Задание со звездочкой

Вместо сочинения файла keywords.yml можно придумать систему, которая бы брала эти слова из самих отзывов (достаточно напарсить все отзывы и взять 20+ самых популярных слов). Или найти какие-нибудь решения, которые анализируют текст на негативность. 
