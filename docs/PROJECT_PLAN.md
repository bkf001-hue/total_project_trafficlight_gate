# 반도체 설계 토탈프로젝트
> 🚦 **신호등 + 차단기 연동 회로 (Traffic Light + Gate Controller)**

---

## 1️⃣ Project Title

**Traffic Light & Gate Controller with 7-Segment Display**

---

## 2️⃣ Objective

FSM(Finite State Machine) 기반의 디지털 신호등 제어 회로를 설계하고,
신호등의 상태(빨강, 노랑, 초록)에 따라 자동으로 차단기(Gate)가 열리고 닫히는 동작을 구현한다.
각 신호의 지속 시간은 타이머를 이용해 제어하며, 남은 시간은 7-Segment 디스플레이에 표시된다.

---

## 3️⃣ System Overview

시스템은 **RED → GREEN → YELLOW → RED** 순으로 순환하며,
각 상태의 지속 시간(예: 5초 / 5초 / 2초)을 Timer Counter로 제어한다.
FSM의 현재 상태에 따라 LED가 점등되고,
게이트 제어 FSM은 해당 신호 상태를 입력받아 **PWM 신호로 차단기 열림/닫힘을 제어**한다.
또한, 현재 상태의 남은 시간이 7-Segment 디스플레이에 출력된다.

---

## 4️⃣ Block Diagram

┌─────────────────────────────────────────────┐
│              Top Module (Main System)       │
│─────────────────────────────────────────────│
│   ┌────────────┐  ┌────────────┐  ┌────────┐ │
│   │ Clock Div. │→│ Timer Cntr │→│ 7-Seg  │ │
│   └──────┬─────┘  └────┬──────┘  └────┬───┘ │
│          │              │              │     │
│          ▼              ▼              ▼     │
│       Traffic FSM ─────────────→ LED Control │
│           │                                   │
│           ▼                                   │
│        Gate FSM ─────────────→ PWM Driver → Servo │
└─────────────────────────────────────────────┘

---

## 5️⃣ Design Modules

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

## 6️⃣ Simulation Plan

* **시뮬레이션 도구:** Icarus Verilog 또는 ModelSim
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

## 7️⃣ Implementation Flow

| 단계               | 사용 툴            | 산출물                |
| ---------------- | --------------- | ------------------ |
| RTL 설계           | Verilog HDL     | 소스 코드 (`*.v`)      |
| 시뮬레이션            | Icarus/ModelSim | 파형 파일 (`.vcd`)     |
| 합성(Synthesis)    | Yosys           | Gate-level Netlist |
| 배치배선(Layout)     | OpenLane        | DEF, GDSII         |
| 검증(Verification) | Magic, Netgen   | DRC/LVS 보고서        |

---

## 8️⃣ Schedule

| 주차      | 주요 작업               | 진행 상태   |
| ------- | ------------------- | ------- |
| 3주차     | 주제 선정 및 개발 환경 설정    | ✅ 완료    |
| 4–5주차   | RTL 코딩 및 시뮬레이션      | 🔄 진행 중 |
| 6–7주차   | 합성 및 타이밍 검증         | ⏳ 예정    |
| 8–9주차   | Layout & Routing 수행 | ⏳ 예정    |
| 10–11주차 | DRC/LVS 검증          | ⏳ 예정    |
| 12–14주차 | 보고서 및 발표 자료 준비      | ⏳ 예정    |

---

## 9️⃣ Expected Outcome

* FSM 기반 신호등 및 차단기 제어 회로 정상 동작 검증
* OpenLane을 이용한 RTL-to-GDSII ASIC 설계 완성
* DRC/LVS 통과한 최종 레이아웃 확보
* LED, 게이트, 7-Segment가 동기화된 완성형 시연 가능
* 전체 칩 설계 플로우를 경험한 문서화된 프로젝트 산출물

---

## 🔟 Repository Info

* **Repository Name:** `total_project_trafficlight_gate`
* **GitHub URL:** `https://github.com/[your_id]/total_project_trafficlight_gate`
* **Document Path:** `/docs/PROJECT_PLAN.md`

---

원하면 지금 이 계획서에 맞게
각 모듈별 `.v` 파일 템플릿 (입출력 포트 + 기본 구조 + 주석 포함) 도 바로 만들어줄까?
예: `traffic_fsm.v`, `gate_fsm.v`, `pwm_driver.v` 같은 거 바로 복붙해서 쓸 수 있게.
