# 반도체 설계 토탈프로젝트
> 🚦 **신호등 + 차단기 연동 회로 (Traffic Light + Gate Controller)**

---

## 1️⃣ 프로젝트 개요

본 프로젝트는 교차로 신호등의 상태(빨강, 노랑, 초록)에 따라
자동으로 차단기(게이트)가 열리고 닫히는 디지털 제어 회로를 설계한다.
각 신호의 지속 시간은 타이머를 이용해 제어하며, 남은 시간은 7-Segment 디스플레이에 표시된다.
FSM(Finite State Machine) 기반으로 신호등의 상태 전환을 구현하고,
게이트는 해당 신호 상태를 입력으로 받아 PWM 제어를 통해 모터(또는 LED) 동작을 시뮬레이션한다.


---

## 2️⃣ 프로젝트 목표

* FSM 기반 신호등 제어 로직 설계 (RED–GREEN–YELLOW 순환)
* 신호 상태에 따라 자동으로 동작하는 게이트 제어 회로 구현
* PWM을 이용한 게이트 열림/닫힘 제어
* Timer를 이용한 상태 전환 및 시간 표시
* 7-Segment 디스플레이를 통한 신호 카운트 출력


---

## 3️⃣ 동작 시나리오

1. **초기 상태** → RED (차단기 닫힘, LED Red ON, 7-Seg 카운트 시작)
2. RED 종료 후 → GREEN (차단기 열림, LED Green ON)
3. GREEN 종료 후 → YELLOW (대기, LED Yellow ON, 게이트 정지 상태)
4. YELLOW 종료 후 → 다시 RED로 복귀
5. FSM 순환 반복

모든 상태 전이는 Timer 카운터 값에 따라 이루어지며,
게이트 FSM은 Traffic FSM의 상태 신호를 입력받아 PWM 출력으로 제어된다.


---

## 4️⃣ 시스템 블록 다이어그램

```text
┌───────────────────────────────────────────────┐
│     Traffic Light + Gate Control System       │
│───────────────────────────────────────────────│
│                                               │
│ Clock Divider → Timer → Traffic FSM           │
│                       │                      │
│                       ▼                      │
│              RED / YELLOW / GREEN             │
│                       │                      │
│                       ▼                      │
│              Gate FSM (OPEN/CLOSE)            │
│                       │                      │
│                       ▼                      │
│           PWM Driver → Gate (Servo/LED)       │
│                       │                      │
│            7-Segment Display (Time Left)      │
└───────────────────────────────────────────────┘
```

---

## 5️⃣ FSM 설계

### 🚦 Traffic Light FSM

| 상태         | LED 색상    | 지속 시간    | 게이트 상태       |
| ---------- | --------- | -------- | ------------ |
| **RED**    | 🔴 Red    | 5초       | Gate Closed  |
| **GREEN**  | 🟢 Green  | 5초       | Gate Open    |
| **YELLOW** | 🟡 Yellow | 2초       | Gate Waiting |
| **LOOP**   | 반복        | 전체 순환 반복 |              |

---

### 🚧 Gate FSM

| 상태        | 입력     | PWM Duty | 설명     |
| --------- | ------ | -------- | ------ |
| **CLOSE** | RED    | 10%      | 게이트 닫힘 |
| **WAIT**  | YELLOW | 50%      | 게이트 정지 |
| **OPEN**  | GREEN  | 90%      | 게이트 열림 |



---

## 6️⃣ 주요 모듈 구성

| 모듈명               | 기능           | 설명                           |
| ----------------- | ------------ | ---------------------------- |
| `clock_divider.v` | 클록 분주기       | 고속 클록을 1Hz 단위로 분주            |
| `timer.v`         | 타이머 카운터      | 각 신호 상태의 지속 시간 제어            |
| `traffic_fsm.v`   | 신호등 FSM      | RED → GREEN → YELLOW 순환 제어   |
| `gate_fsm.v`      | 차단기 FSM      | 신호 상태에 따른 Gate OPEN/CLOSE 제어 |
| `pwm_driver.v`    | PWM 생성기      | Gate 모터 제어용 듀티비 조절           |
| `seven_segment.v` | 7-Segment 표시 | 남은 시간(초)을 디스플레이로 출력          |
| `top_module.v`    | 통합 모듈        | 전체 서브모듈 연결 및 제어              |



---
## 7️⃣ 구현 및 검증 계획

* **시뮬레이션 도구:** Icarus Verilog + GTKWave로 파형 검증
* **입력:** Clock, Reset
* **출력:**

  * FSM 상태에 따른 신호등 LED 제어
  * PWM 듀티비에 따른 게이트 동작 변화
  * 7-Segment 남은 시간 표시
* **검증 항목:**

  1. FSM 상태 전이 (RED → GREEN → YELLOW 순환)
  2. 각 상태별 타이머 리셋 및 정상 동작 여부
  3. Gate FSM이 Traffic FSM 상태에 맞게 반응하는지 검증
  4. 7-Segment 표시가 시간 카운트와 일치하는지 확인



---

## 8️⃣ 기대 효과

* FSM, Timer, PWM, Display를 결합한 종합 회로 설계 경험
* 실제 신호 제어 시스템의 하드웨어 동작 원리 이해
* FSM 기반 신호등 및 차단기 제어 회로 정상 동작 검증
* 전시회·시연 시 시각적으로 직관적인 결과물 구현
---

## 9️⃣ Repository Info

* **Repository Name:** `total_project_trafficlight_gate`
* **GitHub URL:** `https://github.com/[your_id]/total_project_trafficlight_gate`
* **Document Path:** `/docs/PROJECT_PLAN.md`









