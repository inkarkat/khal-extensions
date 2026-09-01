#!/usr/bin/env bats

load fixture

export TEST="khal-streak::input-events@${BATS_TEST_DIRNAME@Q}/events-title.txt"

@test "list streaks with length 1..4" {
    typeset -a streaks=(
	'2026-08-28 16:30 2026-08-29 23:59'
	'2026-07-31 18:00 2026-08-26 21:00'
	'2026-07-31 18:00 2026-08-26 21:00'
	'2026-05-17 15:00 2026-05-25 20:00'
    )
    for ((i = 0; i < ${#streaks[@]}; i++))
    do
	streak="${streaks[i]}"
	run -0 khal-streak -e 'i\?cyc' -gt $i echo \
	    && assert_output "$streak" \
	    || fail "$i: $streak"
    done

    run -1 khal-streak -e 'i\?cyc' -gt 8 echo
    assert_output 'ERROR: No streaks found.'
}
