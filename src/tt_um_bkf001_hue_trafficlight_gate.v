module tt_um_bkf001_hue_trafficlight_gate (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe
);

  // unused inputs
  wire _unused = &{ui_in, uio_in};

  wire led_r, led_g, led_y;
  wire pwm_out;
  wire [6:0] seg;

  // ✅ 네 top_module 포트명과 반드시 일치해야 함
  top_module u_top (
      .clk     (clk),
      .rst_n   (rst_n),
      .led_r   (led_r),
      .led_g   (led_g),
      .led_y   (led_y),
      .pwm_out (pwm_out),
      .seg     (seg)
  );

  // uo_out: 간단히 LED/PWM만 매핑
  assign uo_out[0] = led_r;
  assign uo_out[1] = led_g;
  assign uo_out[2] = led_y;
  assign uo_out[3] = pwm_out;
  assign uo_out[7:4] = 4'b0000;

  // uio_out: 7-seg를 매핑
  assign uio_out[6:0] = seg[6:0];
  assign uio_out[7]   = 1'b0;

  // uio_oe: seg 핀만 출력으로 사용
  assign uio_oe[6:0] = 7'b1111111;
  assign uio_oe[7]   = 1'b0;

endmodule
