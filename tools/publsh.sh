#!/bin/zsh

pushTag(){
    currentDir=$(pwd)
    [ ! -d "$1" ] && echo "[ERROR] chart $1 does not exist" && exist 1
    cd "$1"
    rm *.tgz
    helm package . --version  "$CI_COMMIT_REF_SLUG"
    helm cm-push --force . upy_default --version  "$CI_COMMIT_REF_SLUG"
    rm *.tgz
    cd "$currentDir"
}
pushMaster(){
    currentDir=$(pwd)
    [ ! -d "$1" ] && echo "[ERROR] chart $1 does not exist" && exist 1
    cd "$1"
    rm *.tgz
    helm package . --version  0.0.0-master
    helm cm-push --force . upy_default --version  0.0.0-master
    rm *.tgz
    cd "$currentDir"
}

push(){
    currentDir=$(pwd)
    [ ! -d "$1" ] && echo "[ERROR] chart $1 does not exist" && exist 1
    cd "$1"
    rm *.tgz
    helm package .
    helm cm-push --force . upy_default
    rm *.tgz
    cd "$currentDir"
}
pushMaster hello
pushMaster dns
pushMaster spring-boot
pushMaster services-dependency

export CI_COMMIT_REF_SLUG=0.5.0

pushTag hello
pushTag dns
pushTag spring-boot
pushTag services-dependency
