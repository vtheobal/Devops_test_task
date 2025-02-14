#!/bin/bash

# Директория логов
LOG_DIR="/home/soroka/Devops_test_task/ex2/folder_text"

# Слово для поиска
SEARCH_TERM="php7.4"

# Запись таймстемпа начала
start_time=$(date +%s%3N)

# Поиск слова в файлах логов и подсчет количества совпадений
count=$(grep -i -r "$SEARCH_TERM" "$LOG_DIR" | wc -l)

# Запись таймстемпа конца
end_time=$(date +%s%3N)

# Подсчет времени выполнения
execution_time=$((end_time - start_time))

# Вывод результата
echo "Количество строк с совпадением '$SEARCH_TERM': $count"
echo "Время выполнения скрипта: $execution_time миллисекунд"