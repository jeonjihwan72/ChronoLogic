// ALARM_FND.V

module ALARM_FND(
	RESETN, CLK,
	ENABLE,
	SEG_COM, SEG_DATA,
	A_H10, A_H1, A_M10, A_M1
);

input RESETN, CLK;
input ENABLE;
input [3:0] A_H10, A_H1, A_M10, A_M1;

output [3:0] SEG_COM;
output [7:0] SEG_DATA;

reg [3:0] SEG_COM;
reg [7:0] SEG_DATA;

reg [7:0] A_ASCII_H10, A_ASCII_H1, A_ASCII_M10, A_ASCII_M1;

reg [1:0] CNT_SCAN;

always @(*) 
begin
    case (A_H10)
			4'd0:	A_ASCII_H10 = 8'b00111111; // '0'
			4'd1: A_ASCII_H10 = 8'b00000110; // '1'
			4'd2: A_ASCII_H10 = 8'b01011011; // '2'
			4'd3: A_ASCII_H10 = 8'b01001111; // '3'
			4'd4: A_ASCII_H10 = 8'b01100110; // '4'
			4'd5: A_ASCII_H10 = 8'b01101101; // '5'
			4'd6: A_ASCII_H10 = 8'b01111101; // '6'
			4'd7: A_ASCII_H10 = 8'b00000111; // '7'
			4'd8: A_ASCII_H10 = 8'b01111111; // '8'
			4'd9: A_ASCII_H10 = 8'b01101111; // '9'
			default: A_ASCII_H10 = 8'b00000000; // 공백
    endcase
	 
	 case (A_H1)
			4'd0:	A_ASCII_H1 = 8'b10111111; // '0'
			4'd1: A_ASCII_H1 = 8'b10000110; // '1'
			4'd2: A_ASCII_H1 = 8'b11011011; // '2'
			4'd3: A_ASCII_H1 = 8'b11001111; // '3'
			4'd4: A_ASCII_H1 = 8'b11100110; // '4'
			4'd5: A_ASCII_H1 = 8'b11101101; // '5'
			4'd6: A_ASCII_H1 = 8'b11111101; // '6'
			4'd7: A_ASCII_H1 = 8'b10000111; // '7'
			4'd8: A_ASCII_H1 = 8'b11111111; // '8'
			4'd9: A_ASCII_H1 = 8'b11101111; // '9'
			default: A_ASCII_H1 = 8'b00000000; // 공백
    endcase
	 
	 case (A_M10)
			4'd0:	A_ASCII_M10 = 8'b00111111; // '0'
			4'd1: A_ASCII_M10 = 8'b00000110; // '1'
			4'd2: A_ASCII_M10 = 8'b01011011; // '2'
			4'd3: A_ASCII_M10 = 8'b01001111; // '3'
			4'd4: A_ASCII_M10 = 8'b01100110; // '4'
			4'd5: A_ASCII_M10 = 8'b01101101; // '5'
			4'd6: A_ASCII_M10 = 8'b01111101; // '6'
			4'd7: A_ASCII_M10 = 8'b00000111; // '7'
			4'd8: A_ASCII_M10 = 8'b01111111; // '8'
			4'd9: A_ASCII_M10 = 8'b01101111; // '9'
			default: A_ASCII_M10 = 8'b00000000; // 공백
    endcase
	 
	 case (A_M1)
			4'd0:	A_ASCII_M1 = 8'b00111111; // '0'
			4'd1: A_ASCII_M1 = 8'b00000110; // '1'
			4'd2: A_ASCII_M1 = 8'b01011011; // '2'
			4'd3: A_ASCII_M1 = 8'b01001111; // '3'
			4'd4: A_ASCII_M1 = 8'b01100110; // '4'
			4'd5: A_ASCII_M1 = 8'b01101101; // '5'
			4'd6: A_ASCII_M1 = 8'b01111101; // '6'
			4'd7: A_ASCII_M1 = 8'b00000111; // '7'
			4'd8: A_ASCII_M1 = 8'b01111111; // '8'
			4'd9: A_ASCII_M1 = 8'b01101111; // '9'
			default: A_ASCII_M1 = 8'b00000000; // 공백
    endcase
end

always @(posedge CLK)
begin
	if (ENABLE)
		begin
			if (~RESETN)
				CNT_SCAN <= 0;
			else
				begin
					if (CNT_SCAN >= 3)
						CNT_SCAN <= 0;
					else
						CNT_SCAN <= CNT_SCAN + 1;
				end
		end
end

always @(posedge CLK)
begin
	if (ENABLE)
		begin
			if (~RESETN)
				begin
					SEG_COM <= 4'b1111;
					SEG_DATA <= 8'b00000000;
				end
			else
				begin
					case(CNT_SCAN)
						0:
						begin
							SEG_COM <= 4'h7;
							SEG_DATA <= A_ASCII_M1;
						end
						1:
						begin
							SEG_COM <= 4'hB;
							SEG_DATA <= A_ASCII_M10;
						end
						2:
						begin
							SEG_COM <= 4'hD;
							SEG_DATA <= A_ASCII_H1;
						end
						3:
						begin
							SEG_COM <= 4'hE;
							SEG_DATA <= A_ASCII_H10;
						end
						default:
						begin
							SEG_COM <= 4'hF;
							SEG_DATA <= 8'h00;
						end
					endcase
				end
		end
	else
		begin
			SEG_COM <= 4'b1111;
			SEG_DATA <= 8'b00000000;
		end
end

endmodule