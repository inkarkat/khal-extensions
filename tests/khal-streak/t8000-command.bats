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

@test "list streaks for counts" {
    typeset -A data=(
	[1]='2026-08-18 00:00 2026-08-20 23:59'
	[2]='2026-07-11 00:00 2026-07-12 23:59'
	[3]='2026-06-01 08:00 2026-06-01 12:00'
    )

    for count in "${!data[@]}"
    do
	run -0 khal-streak -e Urlaub --count $count echo \
	    && assert_output "${data["$count"]}" \
	    || fail "$count should yield ${data["$count"]}"
    done

    run -1 khal-streak -e Urlaub --count 4 echo
    assert_output 'ERROR: Only 3 streaks found.'
}
