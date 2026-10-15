# Traffic Light & Gate Controller

**Verilog RTL Design · FSM · PWM · 7-Segment · Tiny Tapeout**

교통신호 상태에 따라 LED와 차단기 제어용 PWM 신호를 출력하는 디지털 회로 설계 프로젝트입니다. Verilog로 모듈을 나누어 작성하고, Testbench로 동작을 확인한 뒤 GDS 산출물을 정리했습니다.

## 동작 구조

```text
clk / rst_n
    |
Clock Divider → tick
    |
Traffic FSM + Timer ──→ RED / GREEN / YELLOW LEDs
    |          |
    |          └──→ 7-Segment (remaining time)
    └──→ PWM Driver ──→ gate PWM output
```

신호등은 **RED → GREEN → YELLOW → RED** 순서로 전환됩니다. 기본 상태 지속시간은 RED 5 tick, GREEN 5 tick, YELLOW 2 tick이며, `top_module.v`은 시뮬레이션을 위해 DIV=50을 사용합니다. 여기서 tick은 실제 1초와 같지 않습니다.

| 상태 | LED | PWM duty |
|---|---|---:|
| RED | 빨강 | 10% |
| GREEN | 초록 | 90% |
| YELLOW | 노랑 | 50% |

PWM은 차단기 제어를 가정한 논리 신호이며, 실제 모터 구동까지 검증한 것은 아닙니다. 별도 `gate_fsm.v` 파일도 있지만 현재 최상위 모듈에서는 사용하지 않습니다.

## 주요 파일

| 경로 | 역할 |
|---|---|
| [src/traffic_fsm.v](src/traffic_fsm.v) | 신호등 FSM 및 Timer 제어 |
| [src/timer.v](src/timer.v) | 상태별 카운트다운 |
| [src/clock_divider.v](src/clock_divider.v) | tick 생성 |
| [src/pwm_driver.v](src/pwm_driver.v) | 상태별 PWM duty 출력 |
| [src/seven_segment.v](src/seven_segment.v) | 잔여시간 표시 |
| [src/top_module.v](src/top_module.v) | RTL 모듈 통합 |
| [src/tt_um_bkf001_hue_trafficlight_gate.v](src/tt_um_bkf001_hue_trafficlight_gate.v) | Tiny Tapeout I/O 매핑 |

## 검증

`make test`로 다음 3가지 테스트를 실행할 수 있습니다.

| Testbench | 확인한 내용 |
|---|---|
| `tb_traffic_fsm.sv` | 신호등 상태 전환 순서 |
| `tb_gate_pwm.sv` | RED·YELLOW·GREEN 간 PWM 출력 비율 순서 |
| `tb_top_smoke.sv` | 통합 회로에서 GREEN·YELLOW 상태 도달 여부 |

```bash
make test
```

Icarus Verilog와 make가 필요합니다. GitHub Actions 테스트 실행 기록도 [Actions](../../actions)에서 확인할 수 있습니다.

## 설계 산출물

- [GDS 아카이브](deliverables/tt_um_bkf001_hue_trafficlight_gate_gds.tar.gz)
- [Tiny Tapeout 설정](info.yaml)
- [Project Plan](docs/PROJECT_PLAN.md)

GDS 파일은 설계 산출물로 저장한 것이며, 실제 칩 제작이나 실측까지 확인한 결과는 아닙니다.
