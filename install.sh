#!/bin/bash

basedir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

function check_and_add_alias {
    current_alias="alias kc=\". ${basedir}/kubeconfigs\""
    existing_alias=$(grep 'alias kc=' $1)
    retval=$?
    if [ $retval -gt 0 ]; then
        echo "" >> $1
        echo "# kubeconfigs alias" >> $1
        echo "alias kc=\". ${basedir}/kubeconfigs\"" >> $1
        echo "" >> $1
    elif [ ! "$existing_alias" = "$current_alias" ]; then
        echo "Existing alias in $1 is: $existing_alias"
        echo "Please update it manually to:"
        echo "$current_alias"
    fi
}

if [ -f ~/.zshrc ]; then
    check_and_add_alias ~/.zshrc
fi

if [ -f ~/.bashrc ]; then
    check_and_add_alias ~/.bashrc
fi
