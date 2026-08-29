#!/usr/bin/env bats

load fixture

export TEST=khal-streak=calculateStreaks

@test "single event is calculated as 0-year streak" {
    run -0 khal-streak --yearly <<'EOF'
2026-08-27 08:00	2026-08-27 09:00
EOF
    assert_output - <<'EOF'
0	2026-08-27 08:00	2026-08-27 09:00
EOF
}

@test "two events on the same year are calculated as 0-year streak spanning both events" {
    run -0 khal-streak --yearly <<'EOF'
2026-08-27 10:00	2026-08-27 11:00
2026-01-04 08:00	2026-08-04 09:00
EOF
    assert_output - <<'EOF'
0	2026-01-04 08:00	2026-08-27 11:00
EOF
}

@test "two events on subsequent years are calculated as 1-year streak spanning both events" {
    run -0 khal-streak --yearly <<'EOF'
2026-08-22 10:00	2026-08-22 11:00
2025-09-28 08:00	2026-09-28 09:00
EOF
    assert_output - <<'EOF'
1	2025-09-28 08:00	2026-08-22 11:00
EOF
}

@test "three events on subsequent years are calculated as 2-year streak spanning all events" {
    run -0 khal-streak --yearly <<'EOF'
2026-08-28 08:00	2026-08-28 09:00
2025-09-22 10:00	2025-09-22 11:00
2024-06-11 09:00	2024-06-11 15:00
EOF
    assert_output - <<'EOF'
2	2024-06-11 09:00	2026-08-28 09:00
EOF
}

@test "two events with one year in between are calculated as 0-year streaks" {
    run -0 khal-streak --yearly <<'EOF'
2026-08-15 10:00	2026-08-15 11:00
2024-12-28 08:00	2024-12-28 09:00
EOF
    assert_output - <<'EOF'
0	2026-08-15 10:00	2026-08-15 11:00
0	2024-12-28 08:00	2024-12-28 09:00
EOF
}
