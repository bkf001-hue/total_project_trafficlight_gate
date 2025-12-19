module traffic_fsm #(
    parameter integer RED_DUR    = 5,
    parameter integer GREEN_DUR  = 5,
    parameter integer YELLOW_DUR = 2
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       tick,       // 1초 개념의 tick
    output reg [1:0]  state,      // 00 RED, 01 GREEN, 10 YELLOW
    output wire       led_r,
    output wire       led_g,
    output wire       led_y,
    output wire [7:0] time_left
);

    localparam [1:0] RED    = 2'b00;
    localparam [1:0] GREEN  = 2'b01;
    localparam [1:0] YELLOW = 2'b10;

    reg        t_start;
    reg [7:0]  t_load;
    wire       t_done;
    wire [7:0] t_left;

    assign time_left = t_left;

    // LED 출력
    assign led_r = (state == RED);
    assign led_g = (state == GREEN);
    assign led_y = (state == YELLOW);

    // timer 인스턴스
    timer u_timer (
        .clk(clk),
        .rst_n(rst_n),
        .tick(tick),
        .start(t_start),
        .enable(1'b1),
        .load_value(t_load),
        .time_left(t_left),
        .done_pulse(t_done)
    );

    // FSM + timer 제어
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state   <= RED;
            t_start <= 1'b1;
            t_load  <= RED_DUR[7:0];
        end else begin
            t_start <= 1'b0;

            if (t_done) begin
                case (state)
                    RED: begin
                        state   <= GREEN;
                        t_start <= 1'b1;
                        t_load  <= GREEN_DUR[7:0];
                    end
                    GREEN: begin
                        state   <= YELLOW;
                        t_start <= 1'b1;
                        t_load  <= YELLOW_DUR[7:0];
                    end
                    default: begin // YELLOW
                        state   <= RED;
                        t_start <= 1'b1;
                        t_load  <= RED_DUR[7:0];
                    end
                endcase
            end
        end
    end
endmodule
