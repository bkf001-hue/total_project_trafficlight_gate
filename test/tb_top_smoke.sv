`timescale 1ns/1ps
module tb_top_smoke;
  reg clk; reg rst_n;
  wire led_r, led_g, led_y;
  wire pwm_out;
  wire [6:0] seg;

  top_module dut(
    .clk(clk), .rst_n(rst_n),
    .led_r(led_r), .led_g(led_g), .led_y(led_y),
    .pwm_out(pwm_out), .seg(seg)
  );

  initial clk=0; always #5 clk=~clk;

  integer i;
  integer seen_green, seen_yellow;

  initial begin
    $dumpfile("tb_top_smoke.vcd"); $dumpvars(0, tb_top_smoke);
    rst_n=0; repeat(20) @(posedge clk); rst_n=1;

    seen_green=0; seen_yellow=0;
    for (i=0; i<10000; i=i+1) begin
      @(posedge clk);
      if (led_g) seen_green=1;
      if (led_y) seen_yellow=1;
    end

    if (!seen_green || !seen_yellow) begin
      $display("[FAIL] top did not reach all states (check tick speed)");
      $finish(1);
    end
    $display("[PASS] tb_top_smoke");
    $finish(0);
  end
endmodule
