#!/bin/bash
{
pwd
#make sure the process is in the correct folder
cd /config

UNTRACKED=$(git ls-files --others --exclude-standard)

if [[ (${UNTRACKED[@]:+${UNTRACKED[@]}} || -n "$( git status --porcelain)")]]
then
  echo "Repo has uncomitted changes"
  git status --porcelain
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
  #eval `ssh-agent -s`
  #ssh-add ~/.ssh/id_rsa
  #ssh-add -l -E sha256
  id
  ls -al /root/.ssh/id_rsa
  ls -al .ssh/id_rsa
  ls -al /data/.ssh/id_rsa
  
  cat .ssh/id_rsa

  cat /data/.ssh/id_rsa
  echo "Committing uncomitted changes"
  git commit -sam "Commit added automatically due to file changed"
  git push --set-upstream origin $CURRENT_BRANCH
  git push
fi
} &>> comitter.log
