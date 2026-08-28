#!/usr/bin/env bats

load fixture

export TEST=khal-streak=calculateStreaks

@test "single event is calculated as 0-month streak" {
    run -0 khal-streak --monthly <<'EOF'
2026-08-27 08:00	2026-08-27 09:00
EOF
    assert_output - <<'EOF'
0	2026-08-27 08:00	2026-08-27 09:00
EOF
}

@test "two events on the same month are calculated as 0-month streak spanning both events" {
    run -0 khal-streak --monthly <<'EOF'
2026-08-27 10:00	2026-08-27 11:00
2026-08-04 08:00	2026-08-04 09:00
EOF
    assert_output - <<'EOF'
0	2026-08-04 08:00	2026-08-27 11:00
EOF
}

@test "two events on subsequent months are calculated as 1-month streak spanning both events" {
    run -0 khal-streak --monthly <<'EOF'
2026-08-22 10:00	2026-08-22 11:00
2026-07-28 08:00	2026-07-28 09:00
EOF
    assert_output - <<'EOF'
1	2026-07-28 08:00	2026-08-22 11:00
EOF
}

@test "three events on subsequent months are calculated as 2-month streak spanning all events" {
    run -0 khal-streak --monthly <<'EOF'
2026-08-28 08:00	2026-08-28 09:00
2026-07-22 10:00	2026-07-22 11:00
2026-06-11 09:00	2026-06-11 15:00
EOF
    assert_output - <<'EOF'
2	2026-06-11 09:00	2026-08-28 09:00
EOF
}

@test "two events with one month in between are calculated as 0-month streaks" {
    run -0 khal-streak --monthly <<'EOF'
2026-08-15 10:00	2026-08-15 11:00
2026-06-28 08:00	2026-06-28 09:00
EOF
    assert_output - <<'EOF'
0	2026-08-15 10:00	2026-08-15 11:00
0	2026-06-28 08:00	2026-06-28 09:00
EOF
}
