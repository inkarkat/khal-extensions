#!/usr/bin/env bats

load fixture

export TEST=khal-streak=calculateStreaks

@test "single event is calculated as 0-24h streak" {
    run -0 khal-streak --every 24h <<'EOF'
2026-08-27 08:00	2026-08-27 09:00
EOF
    assert_output - <<'EOF'
0	2026-08-27 08:00	2026-08-27 09:00
EOF
}

@test "two events on the same day are calculated as 1-24h streak spanning both events" {
    run -0 khal-streak --every 24h <<'EOF'
2026-08-27 10:00	2026-08-27 11:00
2026-08-27 08:00	2026-08-27 09:00
EOF
    assert_output - <<'EOF'
1	2026-08-27 08:00	2026-08-27 11:00
EOF
}

@test "three events on the same day are calculated as 2-24h streak spanning all events" {
    run -0 khal-streak --every 24h <<'EOF'
2026-08-27 18:00	2026-08-27 20:00
2026-08-27 10:00	2026-08-27 11:00
2026-08-27 08:00	2026-08-27 09:00
EOF
    assert_output - <<'EOF'
2	2026-08-27 08:00	2026-08-27 20:00
EOF
}

@test "two events just within 24 hours are calculated as 1-24h streak spanning both events" {
    run -0 khal-streak --every 24h <<'EOF'
2026-08-28 08:00	2026-08-28 09:00
2026-08-27 07:50	2026-08-27 08:00
EOF
    assert_output - <<'EOF'
1	2026-08-27 07:50	2026-08-28 09:00
EOF
}

@test "three events on subsequent days are calculated as 2-24h streak spanning all events" {
    run -0 khal-streak --every 24h <<'EOF'
2026-08-28 08:00	2026-08-28 09:00
2026-08-27 10:00	2026-08-27 11:00
2026-08-26 09:00	2026-08-26 15:00
EOF
    assert_output - <<'EOF'
2	2026-08-26 09:00	2026-08-28 09:00
EOF
}

@test "two events with one day in between are calculated as 0-24h streaks" {
    run -0 khal-streak --every 24h <<'EOF'
2026-08-28 08:00	2026-08-28 09:00
2026-08-26 10:00	2026-08-26 11:00
EOF
    assert_output - <<'EOF'
0	2026-08-28 08:00	2026-08-28 09:00
0	2026-08-26 10:00	2026-08-26 11:00
EOF
}

@test "two events more than 24 hours apart are calculated as 0-24h streaks" {
    run -0 khal-streak --every 24h <<'EOF'
2026-08-28 08:00	2026-08-28 09:00
2026-08-27 07:50	2026-08-27 07:59
EOF
    assert_output - <<'EOF'
0	2026-08-28 08:00	2026-08-28 09:00
0	2026-08-27 07:50	2026-08-27 07:59
EOF
}

@test "overlapping events with one day in between are calculated as 24h streaks spanning all events of that day" {
    run -0 khal-streak --every 24h <<'EOF'
2026-09-15 08:00	2026-09-15 09:00
2026-08-27 09:00	2026-08-27 10:00
2026-08-27 08:30	2026-08-27 09:45
2026-08-27 08:15	2026-08-27 09:30
2026-08-27 08:00	2026-08-27 09:00
2025-01-12 16:30	2025-01-12 17:30
EOF
    assert_output - <<'EOF'
0	2026-09-15 08:00	2026-09-15 09:00
3	2026-08-27 08:00	2026-08-27 10:00
0	2025-01-12 16:30	2025-01-12 17:30
EOF
}
