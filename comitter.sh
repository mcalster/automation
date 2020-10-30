#!/bin/bash

UNTRACKED=$(git ls-files --others --exclude-standard)

if [[ (${UNTRACKED[@]:+${UNTRACKED[@]}} || -n "$( git status --porcelain)")]]
then
  echo "Repo has uncomitted changes"

  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [ $CURRENT_BRANCH = "master" ]
  then
    echo "Currently on $CURRENT_BRANCH creating new branch"
    CURRENT_BRANCH="hassio/auto-created-$(date +'%d-%m-%y-%H-%M')"
    git checkout -b $CURRENT_BRANCH
  fi

  if [ -n $UNTRACKED ]
  then
    echo "Repo has untracked files. Adding the following:"
    for each in "${UNTRACKED[@]}"
    do
      echo $each
      git add $each
    done
  fi

  echo "Committing uncomitted changes"
  git commit -sam "Commit added automatically due to file changed"
  git push --set-upstream origin $CURRENT_BRANCH
  git push
fi