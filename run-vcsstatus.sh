#!/usr/bin/env zsh

## The exe directory.
ZSH_VCS_PROMPT_DIR=$(cd $(dirname $0) && pwd)

source $ZSH_VCS_PROMPT_DIR/vcsstatus.sh

_zsh_vcs_prompt_vcs_detail_info

