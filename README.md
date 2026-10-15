# Traffic Light & Gate Controller | Verilog RTL Design

> **Semiconductor Design Total Project** — FSM-based traffic-light controller with timer, PWM-controlled gate output, 7-segment display, RTL simulation and a GDS deliverable.

**Tools:** Verilog · Icarus Verilog · GitHub Actions · Tiny Tapeout interface

## 1. Project Overview

This project implements a digital traffic-light controller that cycles through **RED → GREEN → YELLOW → RED**. A timer controls state transitions, LEDs indicate the current traffic state, a PWM output represents gate actuation, and a 7-segment output displays the remaining countdown.

The repository includes RTL source code, SystemVerilog testbenches, project documentation and an archived GDS deliverable. The physical gate motor itself was **not** demonstrated in this repository: gate behavior is represented by PWM output.

## 2. System Architecture

```text
                 clk / rst_n
                      |
                Clock Divider
                      |
                     tick
                      v
              Traffic FSM + Timer ------> LED R/G/Y
                      |
                traffic_state
                      +---------------> PWM Driver ----> PWM_GATE
                      |
                  time_left
                      +---------------> 7-Segment Decoder
```

The repository also contains `src/gate_fsm.v`, which maps traffic states to CLOSE/OPEN/WAIT. **The current integrated top module does not instantiate this separate Gate FSM**: instead, `pwm_driver.v` directly selects its duty value from `traffic_state`.

### Main RTL modules

| File | Function |
|---|---|
| `src/clock_divider.v` | Generates a slower tick from the input clock |
| `src/timer.v` | Maintains the countdown and generates timer completion |
| `src/traffic_fsm.v` | Controls RED/GREEN/YELLOW state transitions and LED outputs |
| `src/pwm_driver.v` | Selects PWM duty according to traffic state |
| `src/seven_segment.v` | Converts countdown value to 7-segment output |
| `src/top_module.v` | Connects the active controller modules |
| `src/tt_um_bkf001_hue_trafficlight_gate.v` | Maps the design to the Tiny Tapeout I/O interface |
| `src/gate_fsm.v` | Separate gate-state logic, present but not instantiated by the current top |

## 3. Control Logic

The default RTL state durations are configured as 5 ticks (RED), 5 ticks (GREEN), and 2 ticks (YELLOW). Here, **a tick is not automatically one real second**: the current `top_module.v` uses `clock_divider #(.DIV(50))` to speed up simulation.

| Traffic state | LED | Gate interpretation | PWM duty |
|---|---|---|---:|
| RED | Red | Closed | 10% |
| GREEN | Green | Open | 90% |
| YELLOW | Yellow | Wait | 50% |

PWM values are logical simulation outputs and are **not evidence of calibrated physical servo positions**.

## 4. RTL Verification

The repository includes three testbenches:

| Testbench | What it checks |
|---|---|
| `test/tb_traffic_fsm.sv` | Observes the RED → GREEN → YELLOW → RED sequence |
| `test/tb_gate_pwm.sv` | Checks that measured PWM high counts increase from RED to YELLOW to GREEN |
| `test/tb_top_smoke.sv` | Checks that the integrated top reaches GREEN and YELLOW |

Run locally with **Icarus Verilog** and **make** installed:

```bash
make test
```

The Makefile runs all three tests. GitHub Actions also runs `make test` on pushes and pull requests. The recorded workflow executions on this repository show **three successful test runs** as of 2025-12-19.

[View verification workflow](../../actions/workflows/makefile.yml)

**Verification scope:** These tests establish the specified state-sequence, PWM ordering, and integrated smoke-test behavior; they do not constitute exhaustive functional, timing, or silicon validation.

## 5. Tiny Tapeout Interface & GDS

The design includes a Tiny Tapeout-compatible wrapper:

- `uo_out[0:2]`: red, green and yellow LEDs
- `uo_out[3]`: PWM gate output
- `uio_out[0:6]`: 7-segment outputs

The configured project metadata is available in [info.yaml](info.yaml).

**Stored GDS deliverable:**

[`deliverables/tt_um_bkf001_hue_trafficlight_gate_gds.tar.gz`](deliverables/tt_um_bkf001_hue_trafficlight_gate_gds.tar.gz)

The GDS archive is present in the repository. Its existence does not independently establish a fabrication run, physical chip test, or acceptance by an external submission service.

## 6. Repository Structure

```text
src/                 Verilog RTL modules and Tiny Tapeout wrapper
test/                RTL verification testbenches
docs/                Detailed design plan and technical notes
deliverables/        Archived GDS file
.github/workflows/    Automated make test workflow
info.yaml            Tiny Tapeout project metadata
Makefile             Local simulation and test commands
```

For detailed design decisions and state diagrams, see [Project Plan](docs/PROJECT_PLAN.md) and [Technical Notes](docs/info.md).

## 7. Scope and Next Steps

**Implemented and evidenced here:** modular RTL, state-controlled LED outputs, timer and PWM logic, 7-segment output, automated simulation tests, Tiny Tapeout wrapper and stored GDS artifact.

**Not independently verified here:** physical gate actuation, silicon fabrication or measurement, exhaustive corner-case validation and external submission acceptance.

Potential extensions include integrating the separate Gate FSM into the active top module, adding stronger assertions and edge-case tests, and testing physical gate hardware.
