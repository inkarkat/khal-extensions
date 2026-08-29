#!/usr/bin/env bats

load fixture

export TEST=khal-streak=calculateStreaks

@test "single event is calculated as 0-workday streak" {
    run -0 khal-streak --workday <<'EOF'
2026-08-27 08:00	2026-08-27 09:00
EOF
    assert_output - <<'EOF'
0	2026-08-27 08:00	2026-08-27 09:00
EOF
}

@test "two events on the same workday are calculated as 0-workday streak spanning both events" {
    run -0 khal-streak --workday <<'EOF'
2026-08-27 10:00	2026-08-27 11:00
2026-08-27 08:00	2026-08-27 09:00
EOF
    assert_output - <<'EOF'
0	2026-08-27 08:00	2026-08-27 11:00
EOF
}

@test "two sole events on subsequent workdays are calculated as 1-workday streak spanning both events" {
    run -0 khal-streak --workday <<'EOF'
2026-08-28 08:00	2026-08-28 09:00
2026-08-27 10:00	2026-08-27 11:00
EOF
    assert_output - <<'EOF'
1	2026-08-27 10:00	2026-08-28 09:00
EOF
}

@test "two events on subsequent workdays ignore weekend days and are calculated as 1-workday streak spanning both events" {
    run -0 khal-streak --workday <<'EOF'
2026-08-29 09:00	2026-08-29 09:30
2026-08-28 08:00	2026-08-28 09:00
2026-08-27 10:00	2026-08-27 11:00
2026-08-23 09:00	2026-08-23 09:30
EOF
    assert_output - <<'EOF'
1	2026-08-27 10:00	2026-08-28 09:00
EOF
}

@test "two events on Monday and Friday are calculated as 1-workday streak spanning both events" {
    run -0 khal-streak --workday <<'EOF'
2026-08-24 08:00	2026-08-24 09:00
2026-08-21 10:00	2026-08-21 11:00
EOF
    assert_output - <<'EOF'
1	2026-08-21 10:00	2026-08-24 09:00
EOF
}

@test "three eligible events on Thursday, Friday, Saturday, Sunday, and Monday are calculated as 2-workday streak spanning all events" {
    run -0 khal-streak --workday <<'EOF'
2026-08-25 08:00	2026-08-25 09:00
2026-08-24 10:00	2026-08-24 11:00
2026-08-23 19:00	2026-08-23 19:30
2026-08-22 09:00	2026-08-22 09:30
2026-08-21 09:00	2026-08-21 15:00
EOF
    assert_output - <<'EOF'
2	2026-08-21 09:00	2026-08-25 09:00
EOF
}

@test "two events with one workday in between are calculated as 0-workday streaks" {
    run -0 khal-streak --workday <<'EOF'
2026-08-28 08:00	2026-08-28 09:00
2026-08-26 10:00	2026-08-26 11:00
EOF
    assert_output - <<'EOF'
0	2026-08-28 08:00	2026-08-28 09:00
0	2026-08-26 10:00	2026-08-26 11:00
EOF
}

@test "two events on Thursday and Monday are calculated as 0-workday streaks" {
    run -0 khal-streak --workday <<'EOF'
2026-08-24 08:00	2026-08-24 09:00
2026-08-20 10:00	2026-08-20 11:00
EOF
    assert_output - <<'EOF'
0	2026-08-24 08:00	2026-08-24 09:00
0	2026-08-20 10:00	2026-08-20 11:00
EOF
}

@test "two events on Friday and Tuesday are calculated as 0-workday streaks" {
    run -0 khal-streak --workday <<'EOF'
2026-08-25 08:00	2026-08-25 09:00
2026-08-21 10:00	2026-08-21 11:00
EOF
    assert_output - <<'EOF'
0	2026-08-25 08:00	2026-08-25 09:00
0	2026-08-21 10:00	2026-08-21 11:00
EOF
}
