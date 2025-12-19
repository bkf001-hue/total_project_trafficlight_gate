module timer #(
    parameter integer W = 8
)(
    input  wire           clk,
    input  wire           rst_n,
    input  wire           tick,
    input  wire           start,        // 1이면 load_value로 재시작
    input  wire           enable,
    input  wire [W-1:0]   load_value,   // duration (예: 5)
    output reg  [W-1:0]   time_left,    // 남은 시간
    output wire           done_pulse     // 마지막 1초에서 tick이 들어오면 1클럭 펄스
);
    assign done_pulse = (enable && tick && (time_left == 8'd1));

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            time_left <= {W{1'b0}};
        end else begin
            if (start) begin
                time_left <= load_value;
            end else if (enable && tick) begin
                if (time_left != 0)
                    time_left <= time_left - 1'b1;
            end
        end
    end
endmodule
