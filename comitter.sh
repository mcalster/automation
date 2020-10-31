#!/bin/bash
{
#make sure the process is in the correct folder
UNTRACKED=$(git ls-files --others --exclude-standard)

if [[ (${UNTRACKED[@]:+${UNTRACKED[@]}} || -n "$( git status --porcelain)")]]
then
  echo "Repo has uncomitted changes:"

  echo "Tracked changes"
  git status --porcelain
  echo "Untracked changes"
  git ls-files --others --exclude-standard

  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  echo "Currently on $CURRENT_BRANCH"
  if [ $CURRENT_BRANCH = "master" ]
  then
    echo "Creating new branch"
    CURRENT_BRANCH="hassio/auto-created-$(date +'%d-%m-%y-%H-%M')"
    git checkout -b $CURRENT_BRANCH
  fi

  if [ ${UNTRACKED[@]:+${UNTRACKED[@]}} ]
  then
    echo "Repo has untracked files. Adding the following:"
    for each in "${UNTRACKED[@]}"
    do
      echo $each
      git add $each
    done
  fi
  eval `ssh-agent -s`
  ssh-add .ssh/id_rsa
  ssh-add -l -E sha256

  echo "Committing uncomitted changes"
  git commit -sam "Commit added automatically due to file changed"
  git push --set-upstream origin $CURRENT_BRANCH
  git push

  echo "Do some git house Keeping"
  git fetch --prune
  git remote prune origin
  # remove all branches not present remote if merged
  git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -d
  git gc
  echo "Git house Keeping done :-)"
fi
} &>> comitter.log
