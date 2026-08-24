#!/bin/bash source-this-script

_khal_complete()
{
    local IFS=$'\n'
    typeset -a extensions=(); readarray -t extensions < <(compgen -A command -- 'khal-' 2>/dev/null)
    extensions=("${extensions[@]/#khal-/}")

    if [ $COMP_CWORD -ge 3 ] && contains "${COMP_WORDS[1]}-${COMP_WORDS[2]}" "${extensions[@]}"; then
	local khalExtension="_khal_${COMP_WORDS[1]//-/_}_${COMP_WORDS[2]//-/_}_complete"
	# Completing a sub-extension; delegate to its custom completion function (if
	# available)
	if type -t "$khalExtension" >/dev/null; then
	    typeset -a save_COMP_WORDS=("${COMP_WORDS[@]}"); COMP_WORDS=("khal-${COMP_WORDS[1]}-${COMP_WORDS[2]}" "${COMP_WORDS[@]:3}")
		# Allow access to the original command, as COMP_WORDS[0] gets overwritten.
		KHAL_COMMAND="${save_COMP_WORDS[0]}" \
		COMP_CWORD=$((COMP_CWORD-2)) \
		    "$khalExtension" "${COMP_WORDS[0]}" "${save_COMP_WORDS[COMP_CWORD]}" "${save_COMP_WORDS[COMP_CWORD-1]}"
	    COMP_WORDS=("${save_COMP_WORDS[@]}")
	fi
    fi
    if [ $COMP_CWORD -ge 2 ] && contains "${COMP_WORDS[1]}" "${extensions[@]}"; then
	local khalExtension="_khal_${COMP_WORDS[1]//-/_}_complete"
	# Completing an extension; delegate to its custom completion function (if
	# available)
	if type -t "$khalExtension" >/dev/null; then
	    typeset -a save_COMP_WORDS=("${COMP_WORDS[@]}"); COMP_WORDS=("khal-${COMP_WORDS[1]}" "${COMP_WORDS[@]:2}")
		# Allow access to the original command, as COMP_WORDS[0] gets overwritten.
		KHAL_COMMAND="${save_COMP_WORDS[0]}" \
		COMP_CWORD=$((COMP_CWORD-1)) \
		    "$khalExtension" "${COMP_WORDS[0]}" "${save_COMP_WORDS[COMP_CWORD]}" "${save_COMP_WORDS[COMP_CWORD-1]}"
	    COMP_WORDS=("${save_COMP_WORDS[@]}")
	fi
    fi
    if [ $COMP_CWORD -eq 1 ]; then
	typeset -a builtinCommands=(at calendar edit import interactive list new printcalendars printformats printics search)
	# Also offer extensions (khal-extensionname, callable via my khal wrapper
	# function as khal extensionname).
	readarray -O ${#COMPREPLY[@]} -t COMPREPLY < <(compgen -W "${builtinCommands[*]}"$'\n'"${extensions[*]}" -X "!${2}*")
    elif [ $COMP_CWORD -eq 2 ]; then
	# Also offer sub-extensions (khal-extensionname-subextensionname, callable via my
	# khal wrapper function as khal extensionname subextensionname).
	typeset -a subExtensions=(); readarray -t subExtensions < <(compgen -A command -- "khal-${COMP_WORDS[1]}-" 2>/dev/null)
	subExtensions=("${subExtensions[@]/#khal-${COMP_WORDS[1]}-/}")
	readarray -O ${#COMPREPLY[@]} -t COMPREPLY < <(compgen -W "${subExtensions[*]}" -X "!${2}*")
    fi
}
complete -F _khal_complete khal khal-wrapper
