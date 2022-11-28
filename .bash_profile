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

alias server='cd $XEALTH_ROOT/xealth-server'
alias server-docker='cd $XEALTH_ROOT/xealth-server/docker/local'
alias server-recompile='server && rm -rf ./dist && npm run build && npm run docker-watch'
alias server-down='server-docker && docker-compose down --remove-orphans && docker volume prune -f'
alias server-up='server-docker && export COMPOSE_FILE=docker-compose.yml:docker-compose.override.yml:docker-compose.incremental.yml:docker-compose.local-disabled.yml && xp staging-dev && docker-compose up -d '
alias server-up-es='server-docker && export COMPOSE_FILE=docker-compose.yml:docker-compose.override.yml:docker-compose.incremental.yml:docker-compose.local-es.yml:docker-compose.local-disabled.yml && xp staging-dev && docker-compose up -d '
alias server-up-harold='server-docker && export COMPOSE_FILE=docker-compose.yml:docker-compose.override.yml:docker-compose.incremental.yml:docker-compose.local-harold.yml:docker-compose.local-disabled.yml && xp staging-dev && docker-compose up -d '
alias server-up-harold-dev='server-docker && export COMPOSE_FILE=docker-compose.yml:docker-compose.override.yml:docker-compose.incremental.yml:docker-compose.local-harold-dev.yml:docker-compose.local-disabled.yml && xp staging-dev && docker-compose up -d '
alias server-up-local='server-docker && export COMPOSE_FILE=docker-compose.yml:docker-compose.override.yml:docker-compose.incremental.yml:docker-compose.local-harold.yml:docker-compose.local-es.yml:docker-compose.local-disabled.yml && xp staging-dev && docker-compose up -d '
alias server-up-gw='server-docker && export COMPOSE_FILE=docker-compose.yml:docker-compose.override.yml:docker-compose.incremental.yml:docker-compose.local-gw.yml:docker-compose.local-disabled.yml && xp staging-dev && docker-compose up -d '
alias server-test='server-docker && docker-compose exec servertest npm test'
alias server-log='server-docker && docker logs -f xealth-server-1 | bunyan'
alias worker-log='server-docker && docker logs -f xealth-worker-1 | bunyan'
alias orders-log='server-docker && docker logs -f xealth-automated-ordering-1 | bunyan'
alias server-test-unit='server && NODE_ENV=dockerlocal npm run test:unit'
alias server-test-unit-docker='server-docker && docker-compose exec servertest npm run test:run -- -w dist/test/mocha/unit --recursive --exit'
alias server-test-int='server-docker && docker-compose exec servertest npm run test:run -- -w dist/test/mocha/integration --recursive --exit'
alias server-test-leg='server-docker && docker-compose exec servertest npm run test:run -- -w dist/test/mocha/legacy --recursive --exit'
alias server-test-sys='server-docker && docker-compose exec servertest npm run test:run -- -w dist/test/mocha/system --recursive --exit'
alias server-restart='server-docker && docker-compose restart server'
alias server-list-q='aws --endpoint-url http://localhost:4566 --region us-west-2 sqs list-queues'
alias server-purge-q='aws --endpoint-url http://localhost:4566 --region us-west-2 sqs purge-queue'
alias worker-restart='server-docker && docker-compose restart worker'
alias mongo-exec='docker exec -ti xealth_mongo_1 mongo xealth'
