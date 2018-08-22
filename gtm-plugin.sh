#!/usr/bin/env bash

export GTM_STATUS=""
export GTM_NEXT_UPDATE=0
export GTM_LAST_DIR="${PWD}"

function gtm_record_terminal() {
  let epoch=$((`date +%s`))
  if [ "${GTM_LAST_DIR}" != "${PWD}" ] || [ $epoch -ge $GTM_NEXT_UPDATE ]; then
    export GTM_NEXT_UPDATE=$(( $epoch + 30 ))
    export GTM_LAST_DIR="${PWD}"
    if [ "$GTM_STATUS_ONLY" = true ]; then
        GTM_STATUS=$(gtm status -total-only)
    else
        GTM_STATUS=$(gtm record -terminal -status)
    fi
    if [ $? -ne 0 ]; then
        echo "Error running 'gtm record -terminal', you may need to install gtm or upgrade to the latest"
        echo "See http://www.github.com/git-time-metric/gtm for how to install"
    fi
  fi
}

if [ -n "$ZSH_VERSION" ]; then
  autoload add-zsh-hook
  add-zsh-hook precmd gtm_record_terminal
elif [ -n "$BASH_VERSION" ]; then
  PROMPT_COMMAND="gtm_record_terminal; $PROMPT_COMMAND"
else
  echo "Unknown shell not supported for GTM plugin"
fi
