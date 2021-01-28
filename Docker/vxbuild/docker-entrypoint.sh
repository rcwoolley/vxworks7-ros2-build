#!/bin/bash
# https://success.docker.com/article/use-a-script-to-initialize-stateful-container-data

export GID
export GROUP
export HOME
export SITE
export HOSTREF
export UID
export USER
export WRENV

# set -e

INIT_STAMP=/.initialized

if [ ! -f ${INIT_STAMP} ]; then
    if ! id -g ${GROUP} && ! id -ng ${GID}; then
        groupadd --gid ${GID} ${GROUP};
    fi 2> /dev/null
    if ! id -g ${USER} && ! id -ng ${UID}; then
        useradd --create-home --shell /bin/bash --uid ${UID} --gid ${GID} --home-dir ${HOME} ${USER}
    fi 2> /dev/null

    touch ${INIT_STAMP}

    # Check if the container is interactive
    tty > /dev/null
    if [ $? -eq 0 ]; then
        # echo "(interactive shell with pty)"
        su -p -s /bin/bash ${USER}
    else
        # echo "(not interactive with pty)"
        su -c "$*" -p ${USER}
    fi
fi
