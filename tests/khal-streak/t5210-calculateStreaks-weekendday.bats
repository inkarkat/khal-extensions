#!/usr/bin/env bats

load fixture

export TEST=khal-streak=calculateStreaks

@test "single event is calculated as 0-weekendday streak" {
    run -0 khal-streak --weekendday <<'EOF'
2026-08-23 08:00	2026-08-23 09:00
EOF
    assert_output - <<'EOF'
0	2026-08-23 08:00	2026-08-23 09:00
EOF
}

@test "two events on the same weekendday are calculated as 0-weekendday streak spanning both events" {
    run -0 khal-streak --weekendday <<'EOF'
2026-08-22 10:00	2026-08-22 11:00
2026-08-22 08:00	2026-08-22 09:00
EOF
    assert_output - <<'EOF'
0	2026-08-22 08:00	2026-08-22 11:00
EOF
}

@test "two sole events on Saturday and Sunday are calculated as 1-weekendday streak spanning both events" {
    run -0 khal-streak --weekendday <<'EOF'
2026-08-23 08:00	2026-08-23 09:00
2026-08-22 10:00	2026-08-22 11:00
EOF
    assert_output - <<'EOF'
1	2026-08-22 10:00	2026-08-23 09:00
EOF
}

@test "two events on Sunday, Wednesday and Saturday are calculated as 1-weekendday streak spanning both events" {
    run -0 khal-streak --weekendday <<'EOF'
2026-08-22 08:00	2026-08-22 09:00
2026-08-19 18:00	2026-08-19 19:00
2026-08-16 10:00	2026-08-16 11:00
EOF
    assert_output - <<'EOF'
1	2026-08-16 10:00	2026-08-22 09:00
EOF
}

@test "three events on Saturday, Sunday, and the following Saturday are calculated as 2-weekendday streak spanning all events" {
    run -0 khal-streak --weekendday <<'EOF'
2026-08-22 08:00	2026-08-22 09:00
2026-08-21 18:00	2026-08-21 19:00
2026-08-20 18:00	2026-08-20 19:00
2026-08-19 18:00	2026-08-19 19:00
2026-08-18 18:00	2026-08-18 19:00
2026-08-17 18:00	2026-08-17 19:00
2026-08-16 10:00	2026-08-16 11:00
2026-08-15 09:00	2026-08-15 15:00
2026-08-14 18:00	2026-08-14 19:00
EOF
    assert_output - <<'EOF'
2	2026-08-15 09:00	2026-08-22 09:00
EOF
}

@test "two events with one Saturday in between are calculated as 0-weekendday streaks" {
    run -0 khal-streak --weekendday <<'EOF'
2026-08-23 08:00	2026-08-23 09:00
2026-08-16 10:00	2026-08-16 11:00
EOF
    assert_output - <<'EOF'
0	2026-08-23 08:00	2026-08-23 09:00
0	2026-08-16 10:00	2026-08-16 11:00
EOF
}
