SIM=iverilog
VVP=vvp
SIMFLAGS=-g2012
SRC=$(wildcard src/*.v)

.PHONY: test smoke traffic gate clean

test: smoke traffic gate

smoke:
	$(SIM) $(SIMFLAGS) -o sim_smoke.out test/tb_top_smoke.sv $(SRC)
	$(VVP) sim_smoke.out

traffic:
	$(SIM) $(SIMFLAGS) -o sim_traffic.out test/tb_traffic_fsm.sv $(SRC)
	$(VVP) sim_traffic.out

gate:
	$(SIM) $(SIMFLAGS) -o sim_gate.out test/tb_gate_pwm.sv $(SRC)
	$(VVP) sim_gate.out

clean:
	rm -f *.out *.vcd sim_*.out
