#!/bin/bash source-this-script

_khal_complete()
{
    local IFS=$'\n'
    typeset -a aliases=(); readarray -t aliases < <(compgen -A command -- 'khal-' 2>/dev/null)
    aliases=("${aliases[@]/#khal-/}")

    if [ $COMP_CWORD -ge 3 ] && contains "${COMP_WORDS[1]}-${COMP_WORDS[2]}" "${aliases[@]}"; then
	local khalAlias="_khal_${COMP_WORDS[1]//-/_}_${COMP_WORDS[2]//-/_}"
	# Completing a sub-alias; delegate to its custom completion function (if
	# available)
	if type -t "$khalAlias" >/dev/null; then
	    local KHAL_COMMAND="${COMP_WORDS[0]}"   # Allow access to the original command, as COMP_WORDS[0] gets overwritten.
	    COMP_WORDS=("khal-${COMP_WORDS[1]}-${COMP_WORDS[2]}" "${COMP_WORDS[@]:3}")
	    let COMP_CWORD-=2
	    "$khalAlias" "${COMP_WORDS[0]}" "${COMP_WORDS[COMP_CWORD]}" "${COMP_WORDS[COMP_CWORD-1]}"
	    return $?
	fi
    fi
    if [ $COMP_CWORD -ge 2 ] && contains "${COMP_WORDS[1]}" "${aliases[@]}"; then
	local khalAlias="_khal_${COMP_WORDS[1]//-/_}"
	# Completing an alias; delegate to its custom completion function (if
	# available)
	if type -t "$khalAlias" >/dev/null; then
	    local KHAL_COMMAND="${COMP_WORDS[0]}"   # Allow access to the original command, as COMP_WORDS[0] gets overwritten.
	    COMP_WORDS=("khal-${COMP_WORDS[1]}" "${COMP_WORDS[@]:2}")
	    let COMP_CWORD-=1
	    "$khalAlias" "${COMP_WORDS[0]}" "${COMP_WORDS[COMP_CWORD]}" "${COMP_WORDS[COMP_CWORD-1]}"
	    return $?
	fi
    elif [ $COMP_CWORD -eq 1 ]; then
	typeset -a builtinCommands=(at calendar edit import interactive list new printcalendars printformats printics search)
	# Also offer aliases (khal-aliasname, callable via my khal wrapper
	# function as khal aliasname).
	readarray -O ${#COMPREPLY[@]} -t COMPREPLY < <(compgen -W "${builtinCommands[*]}${aliases[*]}" -X "!${2}*")
    fi
}
complete -F _khal_complete khal
