@echo off
set "GRADLE_USER_HOME=D:\.gradle"
set "PUB_CACHE=D:\.pub-cache"
set "TMP=D:\.tmp"
set "TEMP=D:\.tmp"
set "PATH=%PATH%;D:\flutter_sdk\flutter\bin"

cd /d "D:\repositories\AWARD Site\apps\mobile-app"
call flutter pub get
call flutter pub upgrade --major-versions
