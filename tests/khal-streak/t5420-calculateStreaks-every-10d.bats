#!/usr/bin/env bats

load fixture

export TEST=khal-streak=calculateStreaks

@test "single event is calculated as 0-10d streak" {
    run -0 khal-streak --every 10d <<'EOF'
2026-08-27 08:00	2026-08-27 09:00
EOF
    assert_output - <<'EOF'
0	2026-08-27 08:00	2026-08-27 09:00
EOF
}

@test "two events one week apart are calculated as 1-10d streak spanning both events" {
    run -0 khal-streak --every 10d <<'EOF'
2026-08-27 08:50	2026-08-27 09:00
2026-08-20 08:30	2026-08-20 08:40
EOF
    assert_output - <<'EOF'
1	2026-08-20 08:30	2026-08-27 09:00
EOF
}

@test "three events 9 and 10 days apart are calculated as 2-10d streak spanning all events" {
    run -0 khal-streak --every 10d <<'EOF'
2026-08-27 11:00	2026-08-27 11:15
2026-08-18 09:30	2026-08-18 09:45
2026-08-08 08:00	2026-08-08 09:45
EOF
    assert_output - <<'EOF'
2	2026-08-08 08:00	2026-08-27 11:15
EOF
}

@test "two events 10 days and 1 minute apart are calculated as 0-10d streaks" {
    run -0 khal-streak --every 10d <<'EOF'
2026-08-28 12:31	2026-08-28 13:00
2026-08-18 08:00	2026-08-18 12:30
EOF
    assert_output - <<'EOF'
0	2026-08-28 12:31	2026-08-28 13:00
0	2026-08-18 08:00	2026-08-18 12:30
EOF
}
