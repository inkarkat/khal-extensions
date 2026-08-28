#!/usr/bin/env bats

load fixture

export TEST="khal-streak::input-events@${BATS_TEST_DIRNAME@Q}/events-title.txt"

@test "list streaks for various patterns" {
    typeset -A data=(
	['i\?cyc']='2026-07-31 18:00 2026-08-26 21:00'
	[maint]='2026-05-16 00:00 2026-05-16 23:59'
	[Urlaub]='2026-08-18 00:00 2026-08-20 23:59'
	[walk]='2026-02-01 15:00 2026-02-02 21:00'
    )

    for pattern in "${!data[@]}"
    do
	run -0 khal-streak -e "$pattern" echo \
	    && assert_output "${data["$pattern"]}" \
	    || fail "$pattern should yield ${data["$pattern"]}"
    done
}
