module DISP_REMAIN_COUNT(
	input CLK,
   input [3:0] digit,
   input ALARM,
   output reg [6:0] segments
);

always @(posedge CLK) 
begin
    if (ALARM) begin
        case (digit)
            4'd0: segments = 7'b0111111; // 0
            4'd1: segments = 7'b0000110; // 1
            4'd2: segments = 7'b1011011; // 2
            4'd3: segments = 7'b1001111; // 3
            4'd4: segments = 7'b1100110; // 4
            4'd5: segments = 7'b1101101; // 5
            4'd6: segments = 7'b1111101; // 6
            4'd7: segments = 7'b0000111; // 7
            4'd8: segments = 7'b1111111; // 8
            4'd9: segments = 7'b1101111; // 9
            default: segments = 7'b0000000; // OFF
        endcase
    end else begin
        segments = 7'b0000000; // OFF when ALARM is not active
    end
end

endmodule
