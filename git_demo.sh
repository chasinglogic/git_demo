#!/bin/bash

COMMANDS=(
    ""
)

REPO="$(PWD)"
cd ..
OTHER_REPO="$(PWD)/${REPO}_other"

cp -R $REPO $OTHER_REPO
cp -R $REPO/.git $OTHER_REPO/


for COMMAND in "$COMMANDS"; do
    git status
    echo "================================================================================"
    printf "%45s\n" "$COMMAND"
    echo "================================================================================"
    $COMMAND
    read  -n 1
done
