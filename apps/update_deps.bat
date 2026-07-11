@echo off
rem Adjusting paths for C: drive as D: is lost
set "GRADLE_USER_HOME=C:\.gradle"
set "PUB_CACHE=C:\.pub-cache"
set "PATH=%PATH%;C:\Flutter\SDK\flutter_windows_3.24.5-stable\flutter\bin"

cd /d "C:\Users\Dell\StudioProjects\espy project\espy_project\apps"
call flutter pub get
call flutter pub upgrade --major-versions
