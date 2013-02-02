#!/usr/bin/env zsh

## The exe directory.
cwd=$(cd "$(dirname "$0")" && pwd)

source $cwd/vcsstatus.sh

_zsh_vcs_prompt_vcs_detail_info

