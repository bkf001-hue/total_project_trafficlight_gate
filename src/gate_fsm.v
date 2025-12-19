module gate_fsm(
    input  wire      rst_n,
    input  wire [1:0] traffic_state, // 00 RED, 01 GREEN, 10 YELLOW
    output reg  [1:0] gate_state      // 00 CLOSE, 01 OPEN, 10 WAIT
);
    localparam [1:0] CLOSE  = 2'b00;
    localparam [1:0] OPEN   = 2'b01;
    localparam [1:0] WAIT   = 2'b10;

    always @(*) begin
        if (!rst_n) begin
            gate_state = CLOSE;
        end else begin
            case (traffic_state)
                2'b00: gate_state = CLOSE; // RED
                2'b01: gate_state = OPEN;  // GREEN
                default: gate_state = WAIT; // YELLOW
            endcase
        end
    end
endmodule
