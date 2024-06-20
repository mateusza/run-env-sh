#!/usr/bin/env bash

ENV_DIR=~/.local/my.env
HISTFILE="${ENV_DIR}/.bash_history"

ANSIBLE_HOME="${PWD}"
ANSIBLE_CONFIG="${ANSIBLE_HOME}/ansible.cfg"
PYTHON="python3"
VENV_PROVIDERS=(virtualenv venv)
ANSIBLE_PACKAGES=()
HISTFILESIZE=10000
HISTSIZE=10000


if [[ -e run.conf.sh ]]; then
    source run.conf.sh
fi

if [[ -n "$VIRTUAL_ENV_PROMPT" ]] || [[ -n "$VIRTUAL_ENV" ]]
then
    echo "Environment already activated."
    exit 1
fi

if ! [[ -d "$ENV_DIR/bin" ]]
then
    for venv_provider in "${VENV_PROVIDERS[@]}"
    do
        echo "${venv_provider}: creating environment"
        if "$PYTHON" -m "$venv_provider" "$ENV_DIR"
        then
            echo "${venv_provider}: created with $PYTHON"
            echo "virtual env binaries:"
            find "$ENV_DIR" | grep bin
            break
        fi
        echo "${venv_provider}: failed to create environment"
    done
fi

source "$ENV_DIR"/bin/activate

echo "python version: "$("$PYTHON" --version)

if ! [[ -e "$ENV_DIR"/bin/ansible ]] || ! [[ -e "$ENV_DIR"/bin/ansible-lint ]]
then
    "$PYTHON" -m pip install "${ANSIBLE_PACKAGES[@]}"
fi

export ANSIBLE_HOME
export ANSIBLE_CONFIG
export HISTFILE
export HISTFILESIZE
export HISTSIZE

exec bash

