dirs=()
while IFS=  read -r -d $'\0'; do
    dirs+=("$REPLY")
done < <(find ~/Scripts -type d -print0)

res=$PATH
for i in "${dirs[@]}"
do
    if  [[ $i != *'.git'* ]] && [[ $i != *'.idea'* ]]; then
        res="${i}:${res}"
    fi
done

export PATH=$res:$PATH
export PATH=~/xealth/xealth-devtools/tools/xscripts:$PATH
export PATH=/usr/bin:$PATH
export PATH=~/.rd/bin:$PATH

export XEALTH_NPM_TOKEN=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
export XEALTH_ROOT=~/xealth

# Setting PATH for Python 3.10
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"
export PATH

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

etc=/Applications/Docker.app/Contents/Resources/etc
ln -s $etc/docker.bash-completion $(brew --prefix)/etc/bash_completion.d/docker
ln -s $etc/docker-machine.bash-completion $(brew --prefix)/etc/bash_completion.d/docker-machine
ln -s $etc/docker-compose.bash-completion $(brew --prefix)/etc/bash_completion.d/docker-compose

complete -C '/usr/local/bin/aws_completer' aws

for name in $XEALTH_ROOT/xealth-devops/tools/scripts/include/*.inc.sh; do
  if [ -f $name ]; then
    source $name
  else
    echo "Not found: $name"
  fi
done
# Alias functions to save typing (feel free to customize)
alias xp='aws-switch-profile'
complete -F _profiles xp
alias xsh='aws-smsh'
complete -F __aws_smsh_complete xsh

if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

function server() {
  cd $XEALTH_ROOT/xealth-server;
}

function server-docker() {
  cd $XEALTH_ROOT/xealth-server/docker/local;
}

# Xealth-Server ----------------------------------------------------------------

function server-ps() {
  server-docker;
  docker-compose ps;
}

function server-build() {
  server-docker;
  docker compose build;
}

function server-recompile() {
  server;
  rm -rf ./dist;
  npm run build;
  npm run docker-watch;
}

function server-down() {
  server-docker;
  docker compose down --remove-orphans;
  docker volume prune -f;
}

function server-up() {
  AWS_PROFILE=staging-dev-x;
  server-docker;
  export COMPOSE_FILE=docker-compose.yml:docker-compose.override.yml:docker-compose.incremental.yml:docker-compose.local-disabled.yml;
  docker-compose up;
}

function server-up-xqaa() {
  AWS_PROFILE=staging-dev-x;
  server-docker;
  export COMPOSE_FILE=docker-compose.yml:docker-compose.override.yml:docker-compose.incremental.yml;
  docker-compose up;
}

function server-up-locales() {
  AWS_PROFILE=staging-dev-x;
  server-docker;
  export COMPOSE_FILE=docker-compose.yml:docker-compose.override.yml:docker-compose.incremental.yml:docker-compose.local-es.yml
  docker-compose up;
}

function server-logs() {
  server-docker;
  docker logs -f xealth-server-1 | bunyan;
}

function server-worker-logs() {
  server-docker;
  docker logs -f xealth-worker-1 | bunyan;
}

function server-up-pns() {
  AWS_PROFILE=staging-dev-x;
  server-docker;
  export COMPOSE_FILE=docker-compose.yml:docker-compose.override.yml:docker-compose.incremental.yml:docker-compose.local-disabled.yml:docker-compose.local-pns.yml;
  docker-compose up;
}

function server-test-unit() {
  server-docker;
  docker-compose exec servertest npm run test:run -- -w dist/test/mocha/unit --recursive --exit;
}

function server-test-unit-nowait() {
  server;
  npm run build && NODE_ENV=dockerlocal npm run test:unit;
}

function server-test-int() {
  server-docker;
  docker-compose exec servertest npm run test:run -- -w dist/test/mocha/integration --recursive --exit;
}

function server-test-legacy() {
  server-docker;
  docker-compose exec servertest npm run test:run -- -w dist/test/mocha/legacy --recursive --exit;
}

function server-test-system() {
  server-docker;
  docker-compose exec servertest npm run test:run -- -w dist/test/mocha/system --recursive --exit;
}

# Xealth-CMS -------------------------------------------------------------------

function cms-dir() {
  cd $XEALTH_ROOT/xealth-cms;
}

function cms-server-dir() {
  cd $XEALTH_ROOT/xealth-cms/server;
}

function cms-server-dependencies() {
  cd $XEALTH_ROOT/xealth-cms/server/docker/dependencies;
  docker-up;
}

function cms-server() {
  cms-server-dir;
  xp staging-dev;
  npm run start:server;
}

function cms-server-dev() {
  cms-server-dir;
  xp dev-developer;
  npm run start:server;
}

function cms-server-as-tools() {
  cms-server-dir;
  xp tools-support;
  npm run start:server;
}

function cms-worker() {
  cms-server-dir;
  xp staging-dev;
  npm run start:worker;
}

function cms-full() {
  cms-server-dir;
  xp staging-dev;
  npm run start;
}

function cms-ui() {
  cms-dir;
  npm run serve;
}

function cms-deploy-local() {
  xp staging-dev;
  cd ~/xealth/xealth-cms;
  ./node_modules/nx/bin/nx.js run ctf-scripts:test;
  if [ $? -ne 0 ]; then
    return
  fi
  ./node_modules/nx/bin/nx.js run ctf-scripts:deploy-local;
}

function cms-deploy-int() {
  xp staging-dev;
  cd ~/xealth/xealth-cms;
  npm ci;
  ./node_modules/nx/bin/nx.js run ctf-scripts:test;
  if [ $? -ne 0 ]; then
    return
  fi
  ./node_modules/nx/bin/nx.js run ctf-scripts:deploy-int;
}

function cms-run-test-fields() {
  ./node_modules/nx/bin/nx.js run ctf-fields:test;
}

function cms-run-test-email-tool() {
  ./node_modules/nx/bin/nx.js run ctf-email-template-tool:test;
}

function cms-run-test-libs() {
  ./node_modules/nx/bin/nx.js run lib-ctf:test -- --watch true;
}

# Xealth-CMT -------------------------------------------------------------------

function cmt-client-dir() {
  cd $XEALTH_ROOT/xealth-config-ui-tool/client;
}

function cmt-server-dir() {
  cd $XEALTH_ROOT/xealth-config-ui-tool/backend;
}

function cmt-server() {
  cmt-server-dir;
  xp staging-dev;
  npm run start;
}

function cmt-ui-local() {
  cmt-client-dir;
  xp staging-dev;
  npm run start:localFS;
}

function cmt-ui-hosted() {
  cmt-client-dir;
  xp staging-dev;
  npm run start;
}

# Xealth-Grotto ----------------------------------------------------------------

function grotto-backend-dir() {
  cd $XEALTH_ROOT/xealth-grotto/grotto-backend;
}

function deploy-grotto() {
  grotto-backend-dir;
  xp staging-dev;
  npm run build:dev;
  npm run deploy:dev;
}

# Docker -----------------------------------------------------------------------

function docker-down() {
  docker compose down --remove-orphans;
  docker volume prune -f;
}

function docker-build() {
  docker compose build;
}

function docker-up() {
  xp staging-dev;
  docker-compose up;
}

# NVM --------------------------------------------------------------------------

function nvm-12() {
  nvm use v12.22.10;
}

function nvm-14() {
  nvm use v14.19.1;
}

# Git --------------------------------------------------------------------------

function empty-commit() {
  git commit --allow-empty -m rb;
}

function create-init-branch() {
  curBranch=$(git rev-parse --abbrev-ref HEAD)
  git checkout -b "${curBranch}init"
  git push -u origin HEAD
  git checkout $curBranch
  git reset --hard origin/master
  git push -uf origin HEAD
}

function init-personal() {
  ssh-add ~/.ssh/id_ed25519_mpimentel;
}

# Misc -------------------------------------------------------------------------

function ecr-login() {
  xp master-build
  local password=$(aws ecr get-login-password)
  local account=${AWS_ECR_LOGIN_ACCOUNT:-$(aws sts get-caller-identity --query 'Account' --output text)}
  local region=${AWS_REGION:-us-west-2}
  local url="${account}.dkr.ecr.${region}.amazonaws.com"
  docker login \
    --password-stdin \
    --username AWS \
    "$url" <<<$password
}

# alias server-up-temp='server-docker && export COMPOSE_FILE=docker-compose.yml:docker-compose.override.yml:docker-compose.incremental.yml && xp staging-dev && docker-compose up -d '
# alias server-up-es='server-docker && export COMPOSE_FILE=docker-compose.yml:docker-compose.override.yml:docker-compose.incremental.yml:docker-compose.local-es.yml:docker-compose.local-disabled.yml && xp staging-dev && docker-compose up -d '
# alias server-up-harold='server-docker && export COMPOSE_FILE=docker-compose.yml:docker-compose.override.yml:docker-compose.incremental.yml:docker-compose.local-harold.yml:docker-compose.local-disabled.yml && xp staging-dev && docker-compose up -d '
# alias server-up-harold-dev='server-docker && export COMPOSE_FILE=docker-compose.yml:docker-compose.override.yml:docker-compose.incremental.yml:docker-compose.local-harold-dev.yml:docker-compose.local-disabled.yml && xp staging-dev && docker-compose up -d '
# alias server-up-local='server-docker && export COMPOSE_FILE=docker-compose.yml:docker-compose.override.yml:docker-compose.incremental.yml:docker-compose.local-harold.yml:docker-compose.local-es.yml:docker-compose.local-disabled.yml && xp staging-dev && docker-compose up -d '
# alias server-up-gw='server-docker && export COMPOSE_FILE=docker-compose.yml:docker-compose.override.yml:docker-compose.incremental.yml:docker-compose.local-gw.yml:docker-compose.local-disabled.yml && xp staging-dev && docker-compose up -d '
# alias server-restart='server-docker && docker-compose restart server'
# alias server-list-q='aws --endpoint-url http://localhost:4566 --region us-west-2 sqs list-queues'
# alias server-purge-q='aws --endpoint-url http://localhost:4566 --region us-west-2 sqs purge-queue'
# alias worker-restart='server-docker && docker-compose restart worker'
# alias mongo-exec='docker exec -ti xealth_mongo_1 mongo xealth'
# alias server-test-unit='server && NODE_ENV=dockerlocal npm run test:unit'
# alias server-test-leg='server-docker && docker-compose exec servertest npm run test:run -- -w dist/test/mocha/legacy --recursive --exit'
# alias server-test-sys='server-docker && docker-compose exec servertest npm run test:run -- -w dist/test/mocha/system --recursive --exit'
# alias server-test='server-docker && docker-compose exec servertest npm test'
# alias server-log='server-docker && docker logs -f xealth-server-1 | bunyan'
# alias worker-log='server-docker && docker logs -f xealth-worker-1 | bunyan'
# alias orders-log='server-docker && docker logs -f xealth-automated-ordering-1 | bunyan'

# Setting PATH for Python 3.10
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"
export PATH

# Setting PATH for Python 2.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH

PATH=$PATH:/usr/local/bin/docker-credential-ecr-login
export PATH

# Aliases for xealth-qa-automation
source ${XEALTH_ROOT}/xealth-qa-automation/otto-aliases.sh

export JAVA_HOME=$( /usr/libexec/java_home -v16)
export PATH=${JAVA_HOME}/bin:$PATH
export CPPFLAGS="-I${JAVA_HOME}/include"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/mason.pimentel/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
