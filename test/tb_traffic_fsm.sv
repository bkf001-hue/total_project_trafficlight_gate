`timescale 1ns/1ps
module tb_traffic_fsm;

  reg clk; reg rst_n;
  wire [1:0] state;
  wire led_r, led_g, led_y;
  wire [7:0] time_left;

  // tick을 빠르게 주려고 divider 없이 tick 자체를 직접 생성
  reg tick;

  traffic_fsm dut(
    .clk(clk), .rst_n(rst_n), .tick(tick),
    .state(state),
    .led_r(led_r), .led_g(led_g), .led_y(led_y),
    .time_left(time_left)
  );

  initial clk=0; always #5 clk=~clk;

  // tick: 50clk마다 1펄스
  integer c;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin c<=0; tick<=0; end
    else begin
      if (c==49) begin c<=0; tick<=1; end
      else begin c<=c+1; tick<=0; end
    end
  end

  localparam RED=2'b00, GREEN=2'b01, YELLOW=2'b10;

  integer i;
  integer saw_green, saw_yellow, back_to_red;

  initial begin
    $dumpfile("tb_traffic_fsm.vcd"); $dumpvars(0, tb_traffic_fsm);
    rst_n=0; repeat(20) @(posedge clk); rst_n=1;

    saw_green=0; saw_yellow=0; back_to_red=0;

    for (i=0; i<20000; i=i+1) begin
      @(posedge clk);
      if (state==GREEN) saw_green=1;
      if (state==YELLOW) saw_yellow=1;
      if (saw_green && saw_yellow && state==RED) back_to_red=1;
    end

    if (!(saw_green && saw_yellow && back_to_red)) begin
      $display("[FAIL] traffic fsm sequence not observed");
      $finish(1);
    end

    $display("[PASS] tb_traffic_fsm");
    $finish(0);
  end
endmodule
