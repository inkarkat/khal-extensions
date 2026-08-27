#!/usr/bin/env bats

load fixture

export TEST=khal-streak=handleAllAndMultiDay

@test "normal events just get titles removed" {
    run -0 khal-streak <<'EOF'
2026-08-18 08:11	2026-08-18 09:33	breakfast
2026-08-18 12:00	2026-08-18 12:59	lunch
2026-08-18 19:30	2026-08-18 22:00	dinner
EOF
    assert_output - <<'EOF'
2026-08-18 08:11	2026-08-18 09:33
2026-08-18 12:00	2026-08-18 12:59
2026-08-18 19:30	2026-08-18 22:00
EOF
}

@test "3-day all-day vacation is split into 3 full days" {
    run -0 khal-streak <<'EOF'
2026-08-18 00:00	2026-08-20 00:00	3-day vacation
EOF
    assert_output - <<'EOF'
2026-08-18 00:00	2026-08-18 23:59
2026-08-19 00:00	2026-08-19 23:59
2026-08-20 00:00	2026-08-20 23:59
EOF
}

@test "event over 4 days is split across 4 days" {
    run -0 khal-streak <<'EOF'
2026-08-18 07:15	2026-08-21 20:30	4-day workshop
EOF
    assert_output - <<'EOF'
2026-08-18 07:15	2026-08-18 23:59
2026-08-19 00:00	2026-08-19 23:59
2026-08-20 00:00	2026-08-20 23:59
2026-08-21 00:00	2026-08-21 20:30
EOF
}
