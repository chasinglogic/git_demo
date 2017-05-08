#!/bin/bash

# Repeats a character x times
printx_times() {
    str=$1
    num=$2
    v=$(printf "%-${num}s" "$str")
    echo "${v// /$str}"
}

# Used for alignment
COLS=80
HALF_COLS=40

REPO="$(PWD)"
cd ..
OTHER_REPO="$(PWD)/git_demo_other"

if [ -d $OTHER_REPO ]; then
    rm -rf $OTHER_REPO
fi

echo "Copying ${REPO} to ${OTHER_REPO}"

cp -R $REPO $OTHER_REPO
cp -R $REPO/.git $OTHER_REPO/

cd $OTHER_REPO

git checkout -b demo
printf "\nREMOTE CHANGES" >> test.txt
git add --all
git commit -m "make a change in text.txt to cause a conflict"
git push origin demo

cd $REPO

git checkout -b demo

clear

COMMANDS=(
    "git status"
    "git log"
    "git branch -v"
    "git checkout -b make-some-changes"
    "git branch -v"
    "printf 'test\n' > new.txt"
    "git status"
    "git add new.txt"
    "git status"
    "git commit -m 'add new.txt'"
    "git status"
    "printf '\nlocal changes' >> test.txt"
    "git add test.txt"
    "git commit -m 'make some local changes'"
    "git status"
    "git checkout demo"
    "git pull origin demo"
    "git log --graph --full-history --all --color --pretty=format:\"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s\""
    "git merge make-some-changes"
    "git status"
    "git diff test.txt"
)

for COMMAND in "${COMMANDS[@]}"; do
    printx_times "=" $COLS
    printf "%*s\n" $(( (${#COMMAND} + $COLS ) / 2)) "$COMMAND"
    printx_times "=" $COLS
    /bin/bash -c "$COMMAND"
    read  -n 1
    clear
done

# Cleanup
git checkout master > /dev/null &2>/dev/null
git push origin --delete make-some-changes > /dev/null &2>/dev/null
git branch -D make-some-changes > /dev/null &2>/dev/null
git push origin --delete demo > /dev/null &2>/dev/null
git branch -D demo > /dev/null &2>/dev/null
