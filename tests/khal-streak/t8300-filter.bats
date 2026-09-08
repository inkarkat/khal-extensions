#!/usr/bin/env bats

load fixture

export TEST="khal-streak::input-events@${BATS_TEST_DIRNAME@Q}/events-title.txt"

@test "list streaks with length 0..4" {
    typeset -a streaks=(
	'2026-07-04 07:45 2026-07-04 20:45'
	'2026-08-28 16:30 2026-08-29 23:59'
	'2026-05-07 18:45 2026-05-09 19:00'
	'2026-07-20 20:15 2026-07-23 21:00'
	'2026-03-23 18:30 2026-03-27 20:15'
    )
    for ((i = 0; i < ${#streaks[@]}; i++))
    do
	streak="${streaks[i]}"
	run -0 khal-streak -e 'i\?cyc' -eq $i echo \
	    && assert_output "$streak" \
	    || fail "$i: $streak"
    done

    run -1 khal-streak -e 'i\?cyc' -eq 5 echo
    assert_output 'ERROR: No streaks found.'
}
