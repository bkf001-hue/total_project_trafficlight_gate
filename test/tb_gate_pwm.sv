`timescale 1ns/1ps
module tb_gate_pwm;

  reg clk; reg rst_n;
  reg [1:0] traffic_state;
  wire pwm_out;

  pwm_driver dut(
    .clk(clk), .rst_n(rst_n),
    .traffic_state(traffic_state),
    .pwm_out(pwm_out)
  );

  initial clk=0; always #5 clk=~clk;

  integer i;
  integer red_h, yel_h, grn_h;

  task measure(input [1:0] s, output integer high_cnt);
    begin
      traffic_state = s;
      high_cnt = 0;
      for (i=0; i<2000; i=i+1) begin
        @(posedge clk);
        if (pwm_out) high_cnt++;
      end
    end
  endtask

  initial begin
    $dumpfile("tb_gate_pwm.vcd"); $dumpvars(0, tb_gate_pwm);
    rst_n=0; traffic_state=2'b00; repeat(20) @(posedge clk); rst_n=1;

    measure(2'b00, red_h);   // RED
    measure(2'b10, yel_h);   // YELLOW
    measure(2'b01, grn_h);   // GREEN

    $display("PWM high: RED=%0d YEL=%0d GRN=%0d", red_h, yel_h, grn_h);

    if (!(red_h < yel_h && yel_h < grn_h)) begin
      $display("[FAIL] PWM duty ordering mismatch");
      $finish(1);
    end

    $display("[PASS] tb_gate_pwm");
    $finish(0);
  end
endmodule
