#!/usr/bin/env bats

load fixture

export TEST=khal-streak=findMatchingEvents

input="$(cat <<'EOF'
2026-08-18 08:11	2026-08-18 09:33	breakfast
2026-08-18 10:00	2026-08-18 11:45	work session #1
2026-08-18 12:00	2026-08-18 12:59	lunch
2026-08-18 13:00	2026-08-18 15:00	work session #2
2026-08-18 15:00	2026-08-18 15:30	coffee break
2026-08-18 15:30	2026-08-18 18:00	work session #3
2026-08-18 19:30	2026-08-18 22:00	dinner
EOF
)"

@test "filtering events with simple pattern" {
    run -0 khal-streak -e session <<<"$input"
    assert_output - <<'EOF'
2026-08-18 10:00	2026-08-18 11:45	work session #1
2026-08-18 13:00	2026-08-18 15:00	work session #2
2026-08-18 15:30	2026-08-18 18:00	work session #3
EOF
}

@test "filtering events with anchored pattern" {
    run -0 khal-streak -e '^work session #[0-9]$' <<<"$input"
    assert_output - <<'EOF'
2026-08-18 10:00	2026-08-18 11:45	work session #1
2026-08-18 13:00	2026-08-18 15:00	work session #2
2026-08-18 15:30	2026-08-18 18:00	work session #3
EOF
}

@test "filtering events with multiple patterns" {
    run -0 khal-streak -e breakfast -e 'lunch\|dinner' <<<"$input"
    assert_output - <<'EOF'
2026-08-18 08:11	2026-08-18 09:33	breakfast
2026-08-18 12:00	2026-08-18 12:59	lunch
2026-08-18 19:30	2026-08-18 22:00	dinner
EOF
}
