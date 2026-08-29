#!/usr/bin/env bats

load fixture

export TEST="khal-streak::input-events@${BATS_TEST_DIRNAME@Q}/events-title.txt"

@test "list longest streaks for various patterns" {
    typeset -A data=(
	['i\?cyc']='2026-07-31 18:00 2026-08-26 21:00'
	[maint]='2026-05-16 00:00 2026-05-16 23:59'
	[walk]='2026-01-10 18:45 2026-01-12 20:15'
    )

    for pattern in "${!data[@]}"
    do
	run -0 khal-streak --longest -e "$pattern" echo \
	    && assert_output "${data["$pattern"]}" \
	    || fail "$pattern should yield ${data["$pattern"]}"
    done
}

@test "list shortest streaks for various patterns" {
    typeset -A data=(
	['i\?cyc']='2026-07-04 07:45 2026-07-04 20:45'
	[maint]='2026-05-16 00:00 2026-05-16 23:59'
	[walk]='2026-01-20 14:30 2026-01-20 15:15'
    )

    for pattern in "${!data[@]}"
    do
	run -0 khal-streak --shortest -e "$pattern" echo \
	    && assert_output "${data["$pattern"]}" \
	    || fail "$pattern should yield ${data["$pattern"]}"
    done
}
