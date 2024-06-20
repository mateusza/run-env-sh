#!/usr/bin/env bash

ENV_DIR=~/.local/my-ansible.env
HISTFILE="${ENV_DIR}/.bash_history"
ANSIBLE_PACKAGES=(
    ansible
    ansible-lint
)

