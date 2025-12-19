# 반도체 설계 토탈프로젝트
🚦 Traffic Light + Gate Controller (FSM + Timer + PWM + 7-Segment)

---

## 1. 프로젝트 개요
본 프로젝트는 교차로 신호등 상태(RED/GREEN/YELLOW)를 FSM으로 제어하고, 신호등 상태에 따라 차단기(Gate)가 자동으로 열리고 닫히도록 하는 디지털 회로를 설계하였다.  
각 상태의 지속 시간은 Timer로 관리하며, 남은 시간(Time Left)은 7-Segment 디스플레이에 표시된다. Gate 동작은 신호 상태에 따라 PWM duty(10/50/90%)를 변경하여 모터(또는 LED) 동작을 시뮬레이션한다.

---

## 2. 목표 및 요구사항
- RED → GREEN → YELLOW 순환 FSM 구현
- Timer 기반 상태 유지 시간 제어 및 전이
- Traffic 상태에 따른 Gate 동작(OPEN/CLOSE/WAIT) 구현
- PWM duty 변경으로 Gate 동작 시뮬레이션
- 남은 시간을 7-Segment로 표시

---

## 3. 동작 시나리오
1) Reset 이후 초기 상태: **RED** (Gate Close, Red LED ON, 7-Seg 카운트 시작)  
2) RED 종료 → **GREEN** (Gate Open, Green LED ON)  
3) GREEN 종료 → **YELLOW** (Gate Wait/Stop, Yellow LED ON)  
4) YELLOW 종료 → 다시 **RED**  
5) 1~4 반복

모든 상태 전이는 Timer 카운터 값에 의해 결정된다. Gate는 Traffic 상태에 따라 PWM 출력으로 동작한다.

---

## 4. FSM 설계

### 4.1 Traffic Light FSM
| State  | LED | Duration(기본) | Gate |
|---|---|---:|---|
| RED    | Red    | 5s | CLOSED |
| GREEN  | Green  | 5s | OPEN |
| YELLOW | Yellow | 2s | WAIT |

### 4.2 Gate FSM (Traffic 상태 기반)
| Gate State | Traffic Input | PWM Duty | 의미 |
|---|---|---:|---|
| CLOSE | RED    | 10% | 닫힘 |
| WAIT  | YELLOW | 50% | 정지 |
| OPEN  | GREEN  | 90% | 열림 |

---

## 5. 모듈 구성 및 역할 (src/)
| Module | 역할 |
|---|---|
| clock_divider.v | 입력 클록을 분주하여 내부 tick 생성 (1Hz 개념). 시뮬레이션 시간 단축을 위해 분주값(DIV)을 작게 설정할 수 있음 |
| timer.v | 상태 지속시간을 카운트하고 time_left 출력 |
| traffic_fsm.v | RED/GREEN/YELLOW 상태 전이 및 LED 출력 |
| gate_fsm.v | traffic state 입력 받아 gate state 생성(OPEN/CLOSE/WAIT) |
| pwm_driver.v | Traffic(또는 Gate) 상태에 따라 PWM duty(10/50/90%)를 설정하여 pwm_out 생성 |
| seven_segment.v | time_left를 7-seg로 변환 |
| top_module.v | 전체 서브모듈 연결 및 시스템 출력 통합 |

---

## 6. I/O 인터페이스
### top_module 포트
- Input: `clk`, `rst_n`
- Output: `led_r`, `led_g`, `led_y`
- Output: `pwm_out`
- Output: `seg[6:0]`

---

## 7. 테스트(검증) 구성 (test/)
### 테스트 목표
- FSM 상태 전이 순서 및 유지 시간 검증
- Traffic 상태에 맞게 PWM duty가 변경되는지 검증
- Top 통합 동작(Reset 포함) 스모크 검증

### 포함된 테스트
- `tb_traffic_fsm.sv` : RED→GREEN→YELLOW 순환 검증
- `tb_gate_pwm.sv` : traffic state 입력 변화에 따른 pwm duty 레벨 변화 검증
- `tb_top_smoke.sv` : top 통합 스모크 테스트

✅ `make test` 실행 결과 위 3개 테스트 모두 PASS 확인

---

## 8. 실행 방법
### 시뮬레이션 (Icarus Verilog)
- `make test`

또는 개별 실행 예:
- `iverilog -g2012 -o sim.out test/tb_top_smoke.sv src/*.v`
- `vvp sim.out`
- 파형 확인: `gtkwave tb_top_smoke.vcd`

---

## 9. GDS 생성 (Pass 항목)
본 프로젝트는 RTL 기반 설계이며, 제공된 PnR Flow(OpenROAD/OpenLane/과제 스크립트 등)에 따라 GDS를 생성한다.

- 생성 명령(예시): `make gds`
- 산출물 경로(예시): `gds/top_module.gds`

※ 실제 과제 제공 flow에 맞춰 명령/경로를 최종 반영한다.

---

## 10. 제한사항 및 개선 방향
- 현재는 PWM duty로 Gate 동작을 간접 시뮬레이션하며, 실제 서보 각도 제어로 확장 가능
- 7-seg 멀티플렉싱(자리수 확장) 및 버튼 입력(수동 모드) 등 기능 확장 가능
