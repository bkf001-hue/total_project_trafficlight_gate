module top_module(
    input  wire clk,
    input  wire rst_n,
    output wire led_r,
    output wire led_g,
    output wire led_y,
    output wire pwm_out,
    output wire [6:0] seg
);
    wire tick;
    wire [1:0] traffic_state;
    wire [7:0] time_left;

    // 1) 분주 → tick
    clock_divider #(.DIV(50)) u_div (
        .clk(clk),
        .rst_n(rst_n),
        .tick(tick)
    );

    // 2) Traffic FSM + timer
    traffic_fsm u_traffic (
        .clk(clk),
        .rst_n(rst_n),
        .tick(tick),
        .state(traffic_state),
        .led_r(led_r),
        .led_g(led_g),
        .led_y(led_y),
        .time_left(time_left)
    );

    // 3) PWM (traffic_state로 duty 선택)
    pwm_driver u_pwm (
        .clk(clk),
        .rst_n(rst_n),
        .traffic_state(traffic_state),
        .pwm_out(pwm_out)
    );

    // 4) 7-seg: time_left(0~5) 표시
    seven_segment u_7seg (
        .value(time_left[3:0]),
        .seg(seg)
    );

endmodule
