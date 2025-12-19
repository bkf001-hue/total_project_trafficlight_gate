module clock_divider #(
    parameter integer DIV = 50  // 시뮬용 빠른 tick (실제 1Hz면 매우 큰 값으로 설정)
)(
    input  wire clk,
    input  wire rst_n,
    output reg  tick
);
    integer cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt  <= 0;
            tick <= 1'b0;
        end else begin
            if (cnt == DIV-1) begin
                cnt  <= 0;
                tick <= 1'b1;     // 1클럭 펄스
            end else begin
                cnt  <= cnt + 1;
                tick <= 1'b0;
            end
        end
    end
endmodule
