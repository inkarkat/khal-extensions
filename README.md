# khal CLI extensions

_Additions and tweaks to the khal CLI._

These are some personal aliases, shortcuts, and extensions that make (my) work with the [khal](https://lostpackets.de/khal/) / [vdirsyncer](https://github.com/pimutils/vdirsyncer) command-line utilities easier and faster. Some of them may be specific to my environment and workflow, but maybe someone finds a valuable nugget in there.

### Dependencies

* Bash
* [inkarkat/shell-fields](https://github.com/inkarkat/shell-fields) for the `khal-streak` command's streak count filtering
* [inkarkat/shell-debugging](https://github.com/inkarkat/shell-debugging) for debugging (optional)

### Installation

Download all / some selected extensions (note that some have dependencies, though) and put them somewhere in your `PATH`. You can then invoke them via `khal-SUBCOMMAND`.

It is recommended to also use the (Bash, but should also work in Korn shell and Dash) shell functions (e.g. in your `.bashrc`) found at [shell/wrappers.sh](shell/wrappers.sh) to transparently invoke the extensions in the same way as the built-in Kubernetes commands, via `khal SUBCOMMAND`.
