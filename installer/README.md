# Установщик File Sorter RU

Скрипт [Inno Setup 6](https://jrsoftware.org/isinfo.php) для Windows-сборки форка.

## Сборка

1. Соберите программу с CUDA- и CPU-бэкендами (см. раздел «Сборка в Windows» в [README.md](../README.md)):

   ```powershell
   .\app\scripts\build_llama_windows.ps1 cuda=off vulkan=off blas=off
   .\app\scripts\build_llama_windows.ps1 cuda=on vulkan=off cudaarch=89
   .\app\build_windows.ps1 -Configuration Release -Variants Standard
   ```

   Флаг `AI_FILE_SORTER_FORK_BUILD` в этой ветке включён по умолчанию — программа соберётся под именем
   **File Sorter RU**, с папкой настроек `%APPDATA%\FileSorterRU` и без автообновления.

2. Установите Inno Setup и соберите установщик:

   ```powershell
   winget install JRSoftware.InnoSetup
   & "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe" installer\FileSorterRU.iss
   ```

   Готовый файл: `dist\FileSorterRU-<версия>-setup.exe`.

Версия задаётся в начале `FileSorterRU.iss` (`AppVersion`) и в `app/CMakeLists.txt` (`AIFS_FORK_VERSION_SUFFIX`).

## Что делает установщик

- Ставит программу в `C:\Program Files\File Sorter RU` (или в профиль пользователя, если выбрать установку только для себя).
- Создаёт ярлык в меню «Пуск» и, по желанию, на рабочем столе.
- Устанавливает Microsoft Visual C++ Runtime.
- При удалении оставляет настройки (`%APPDATA%\FileSorterRU`) и скачанные модели (`%APPDATA%\aifilesorter\llms`).

Библиотеки CUDA (cudart, cuBLAS) в установщик не входят: для ускорения на видеокарте NVIDIA нужен установленный CUDA Toolkit, иначе программа работает на процессоре.
