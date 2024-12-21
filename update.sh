#!/bin/bash

if [ ! -d ".git" ]; then
  echo "Please deploy using Git."
  exit 1
fi

if ! command -v git &> /dev/null; then
    echo "Git is not installed! Please install git and try again."
    exit 1
fi

git config --global --add safe.directory $(pwd)
git fetch --all && git reset --hard origin/main && git pull origin main
git checkout main
rm -rf composer.lock composer.phar
wget https://github.com/composer/composer/releases/latest/download/composer.phar -O composer.phar
php composer.phar update -vvv

chmod +x *.sh
if [ -f "/etc/init.d/bt" ] || [ "$docker" ]; then
  chown -R www:www $(pwd);
fi


#######################################
# git sync from upstream
#######################################
# git remote -v #查看远程状态
# git remote add -f upstream https://github.com/lizhipay/acg-faka.git #配置完建议再次查看状态确认是否配置成功
#######################################
# git fetch upstream #从上游仓库 fetch 分支和提交点，提交给本地 main，并会被存储在一个本地分支 upstream/main
# git checkout main #切换到本地主分支(如果不在的话)
# git merge upstream/main #把 upstream/main 分支合并到本地 main 上，这样就完成了同步，并且不会丢掉本地修改的内容。
# git push origin main #这一步就把合并后的内容推送到fork后的仓库里了
