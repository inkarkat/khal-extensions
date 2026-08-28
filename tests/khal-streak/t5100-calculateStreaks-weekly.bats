#!/usr/bin/env bats

load fixture

export TEST=khal-streak=calculateStreaks

@test "single event is calculated as 0-week streak" {
    run -0 khal-streak --weekly <<'EOF'
2026-08-27 08:00	2026-08-27 09:00
EOF
    assert_output - <<'EOF'
0	2026-08-27 08:00	2026-08-27 09:00
EOF
}

@test "two events on the same week are calculated as 0-week streak spanning both events" {
    run -0 khal-streak --weekly <<'EOF'
2026-08-27 10:00	2026-08-27 11:00
2026-08-24 08:00	2026-08-24 09:00
EOF
    assert_output - <<'EOF'
0	2026-08-24 08:00	2026-08-27 11:00
EOF
}

@test "two events on subsequent weeks are calculated as 1-week streak spanning both events" {
    run -0 khal-streak --weekly <<'EOF'
2026-08-28 08:00	2026-08-28 09:00
2026-08-22 10:00	2026-08-22 11:00
EOF
    assert_output - <<'EOF'
1	2026-08-22 10:00	2026-08-28 09:00
EOF
}

@test "three events on subsequent weeks are calculated as 2-week streak spanning all events" {
    run -0 khal-streak --weekly <<'EOF'
2026-08-28 08:00	2026-08-28 09:00
2026-08-22 10:00	2026-08-22 11:00
2026-08-11 09:00	2026-08-11 15:00
EOF
    assert_output - <<'EOF'
2	2026-08-11 09:00	2026-08-28 09:00
EOF
}

@test "two events with one week in between are calculated as 0-week streaks" {
    run -0 khal-streak --weekly <<'EOF'
2026-08-28 08:00	2026-08-28 09:00
2026-08-15 10:00	2026-08-15 11:00
EOF
    assert_output - <<'EOF'
0	2026-08-28 08:00	2026-08-28 09:00
0	2026-08-15 10:00	2026-08-15 11:00
EOF
}
