#!/usr/bin/env bats

load fixture

export TEST=khal-streak=calculateStreaks

@test "single event is calculated as 0-Thursday streak" {
    run -0 khal-streak --day-of-week Thursday <<'EOF'
2026-08-27 08:00	2026-08-27 09:00
EOF
    assert_output - <<'EOF'
0	2026-08-27 08:00	2026-08-27 09:00
EOF
}

@test "two events on the same Thursday are calculated as 0-Thursday streak spanning both events" {
    run -0 khal-streak --day-of-week Thursday <<'EOF'
2026-08-27 10:00	2026-08-27 11:00
2026-08-27 08:00	2026-08-27 09:00
EOF
    assert_output - <<'EOF'
0	2026-08-27 08:00	2026-08-27 11:00
EOF
}

@test "two sole events on subsequent Thursdays are calculated as 1-Thursday streak spanning both events" {
    run -0 khal-streak --day-of-week Thursday <<'EOF'
2026-08-27 08:00	2026-08-27 09:00
2026-08-20 10:00	2026-08-20 11:00
EOF
    assert_output - <<'EOF'
1	2026-08-20 10:00	2026-08-27 09:00
EOF
}

@test "two events on subsequent Thursdays ignore other events and are calculated as 1-Thursday streak spanning both events" {
    run -0 khal-streak --day-of-week Thursday <<'EOF'
2026-08-27 08:00	2026-08-27 09:00
2026-08-26 09:00	2026-08-26 09:30
2026-08-21 19:00	2026-08-21 19:30
2026-08-20 10:00	2026-08-20 11:00
2026-08-19 19:00	2026-08-19 19:30
EOF
    assert_output - <<'EOF'
1	2026-08-20 10:00	2026-08-27 09:00
EOF
}

@test "three events on subsequent Thursdays are calculated as 2-Thursday streak spanning all events" {
    run -0 khal-streak --day-of-week Thursday <<'EOF'
2026-08-27 08:00	2026-08-27 09:00
2026-08-24 08:00	2026-08-24 09:00
2026-08-20 10:00	2026-08-20 11:00
2026-08-19 19:00	2026-08-19 19:30
2026-08-13 09:00	2026-08-13 15:00
EOF
    assert_output - <<'EOF'
2	2026-08-13 09:00	2026-08-27 09:00
EOF
}

@test "two events with one Thursday in between are calculated as 0-Thursday streaks" {
    run -0 khal-streak --day-of-week Thursday <<'EOF'
2026-08-27 08:00	2026-08-27 09:00
2026-08-13 10:00	2026-08-13 11:00
EOF
    assert_output - <<'EOF'
0	2026-08-27 08:00	2026-08-27 09:00
0	2026-08-13 10:00	2026-08-13 11:00
EOF
}
