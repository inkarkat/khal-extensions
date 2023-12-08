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
	    typeset -a save_COMP_WORDS=("${COMP_WORDS[@]}"); COMP_WORDS=("khal-${COMP_WORDS[1]}-${COMP_WORDS[2]}" "${COMP_WORDS[@]:3}")
		# Allow access to the original command, as COMP_WORDS[0] gets overwritten.
		KHAL_COMMAND="${save_COMP_WORDS[0]}" \
		COMP_CWORD=$((COMP_CWORD-2)) \
		    "$khalAlias" "${COMP_WORDS[0]}" "${save_COMP_WORDS[COMP_CWORD]}" "${save_COMP_WORDS[COMP_CWORD-1]}"
	    COMP_WORDS=("${save_COMP_WORDS[@]}")
	fi
    fi
    if [ $COMP_CWORD -ge 2 ] && contains "${COMP_WORDS[1]}" "${aliases[@]}"; then
	local khalAlias="_khal_${COMP_WORDS[1]//-/_}"
	# Completing an alias; delegate to its custom completion function (if
	# available)
	if type -t "$khalAlias" >/dev/null; then
	    typeset -a save_COMP_WORDS=("${COMP_WORDS[@]}"); COMP_WORDS=("khal-${COMP_WORDS[1]}" "${COMP_WORDS[@]:2}")
		# Allow access to the original command, as COMP_WORDS[0] gets overwritten.
		KHAL_COMMAND="${save_COMP_WORDS[0]}" \
		COMP_CWORD=$((COMP_CWORD-1)) \
		    "$khalAlias" "${COMP_WORDS[0]}" "${save_COMP_WORDS[COMP_CWORD]}" "${save_COMP_WORDS[COMP_CWORD-1]}"
	    COMP_WORDS=("${save_COMP_WORDS[@]}")
	fi
    fi
    if [ $COMP_CWORD -eq 1 ]; then
	typeset -a builtinCommands=(at calendar edit import interactive list new printcalendars printformats printics search)
	# Also offer aliases (khal-aliasname, callable via my khal wrapper
	# function as khal aliasname).
	readarray -O ${#COMPREPLY[@]} -t COMPREPLY < <(compgen -W "${builtinCommands[*]}"$'\n'"${aliases[*]}" -X "!${2}*")
    elif [ $COMP_CWORD -eq 2 ]; then
	# Also offer sub-aliases (khal-aliasname-subaliasname, callable via my
	# khal wrapper function as khal aliasname subaliasname).
	typeset -a subAliases=(); readarray -t subAliases < <(compgen -A command -- "khal-${COMP_WORDS[1]}-" 2>/dev/null)
	subAliases=("${subAliases[@]/#khal-${COMP_WORDS[1]}-/}")
	readarray -O ${#COMPREPLY[@]} -t COMPREPLY < <(compgen -W "${subAliases[*]}" -X "!${2}*")
    fi
}
complete -F _khal_complete khal
