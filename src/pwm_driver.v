module pwm_driver #(
    parameter integer PWM_PERIOD = 100  // 100카운트 기준으로 duty(10/50/90)
)(
    input  wire      clk,
    input  wire      rst_n,
    input  wire [1:0] traffic_state,   // 테스트에서 바로 넣기 위해 traffic_state 입력으로 둠
    output reg       pwm_out
);
    // RED=10%, YELLOW=50%, GREEN=90%
    reg [6:0] duty_cnt;
    reg [6:0] pwm_cnt;

    always @(*) begin
        case (traffic_state)
            2'b00: duty_cnt = 7'd10; // RED
            2'b01: duty_cnt = 7'd90; // GREEN
            default: duty_cnt = 7'd50; // YELLOW
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pwm_cnt <= 0;
            pwm_out <= 1'b0;
        end else begin
            if (pwm_cnt == PWM_PERIOD-1)
                pwm_cnt <= 0;
            else
                pwm_cnt <= pwm_cnt + 1;

            pwm_out <= (pwm_cnt < duty_cnt);
        end
    end
endmodule
