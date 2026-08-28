#!/usr/bin/env bats

load fixture

export TEST=khal-streak=calculateStreaks

@test "single event is calculated as 0-2h streak" {
    run -0 khal-streak --every 2h <<'EOF'
2026-08-27 08:00	2026-08-27 09:00
EOF
    assert_output - <<'EOF'
0	2026-08-27 08:00	2026-08-27 09:00
EOF
}

@test "two events in the same hour are calculated as 1-2h streak spanning both events" {
    run -0 khal-streak --every 2h <<'EOF'
2026-08-27 08:50	2026-08-27 09:00
2026-08-27 08:30	2026-08-27 08:40
EOF
    assert_output - <<'EOF'
1	2026-08-27 08:30	2026-08-27 09:00
EOF
}

@test "two events in the morning are calculated as 1-2h streak spanning both events" {
    run -0 khal-streak --every 2h <<'EOF'
2026-08-27 10:00	2026-08-27 10:10
2026-08-27 08:30	2026-08-27 08:40
EOF
    assert_output - <<'EOF'
1	2026-08-27 08:30	2026-08-27 10:10
EOF
}

@test "three events in the morning are calculated as 2-2h streak spanning all events" {
    run -0 khal-streak --every 2h <<'EOF'
2026-08-27 11:00	2026-08-27 11:15
2026-08-27 09:30	2026-08-27 09:45
2026-08-27 08:00	2026-08-27 08:15
EOF
    assert_output - <<'EOF'
2	2026-08-27 08:00	2026-08-27 11:15
EOF
}

@test "two overlapping events just within 2 hours are calculated as 1-2h streak spanning both events" {
    run -0 khal-streak --every 2h <<'EOF'
2026-08-28 09:00	2026-08-28 11:00
2026-08-28 08:00	2026-08-28 10:30
EOF
    assert_output - <<'EOF'
1	2026-08-28 08:00	2026-08-28 11:00
EOF
}

@test "two events more than 2 hours apart are calculated as 0-2h streaks" {
    run -0 khal-streak --every 2h <<'EOF'
2026-08-28 12:31	2026-08-28 13:00
2026-08-28 08:00	2026-08-28 10:30
EOF
    assert_output - <<'EOF'
0	2026-08-28 12:31	2026-08-28 13:00
0	2026-08-28 08:00	2026-08-28 10:30
EOF
}
