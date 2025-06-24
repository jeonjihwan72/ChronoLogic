// SET_TIME.v

module SET_TIME(
	CLK, RESETN,
	BT_UP, BT_LOC,
	A_H10, A_H1, A_M10, A_M1,
	ENABLE
);

input CLK, RESETN, ENABLE;
input BT_UP, BT_LOC;
output reg [3:0] A_H10, A_H1, A_M10, A_M1;

reg [3:0] CNT_LOC;

always @(negedge BT_LOC)
begin
	if(ENABLE)
		begin
			if (~RESETN)
				CNT_LOC <= 0;
			else
				begin
					if (CNT_LOC >= 3)
						CNT_LOC <= 0;
					else
						CNT_LOC <= CNT_LOC + 1;
				end
		end
end

always @(negedge BT_UP)
begin
	if(ENABLE)
		begin
			if (~RESETN)
				begin
					A_H10 <= 0;
					A_H1 <= 0;
					A_M10 <= 0;
					A_M1 <= 0;
				end
			else
				begin
					case(CNT_LOC)
						0:
							begin
								if(A_M1 >= 9)
									A_M1 <= 0;
								else
									A_M1 <= A_M1 + 1;
							end
						1:
							begin
								if(A_M10 >= 5)
									A_M10 <= 0;
								else
									A_M10 <= A_M10 + 1;
							end
						2:
							begin
								if ((A_H10 == 2 && A_H1 >= 3) || A_H1 >= 9)
									 A_H1 <= 0;
								else
									 A_H1 <= A_H1 + 1;
							end
						3:
							begin
								if(A_H10 >= 2)
									A_H10 <= 0;
								else
									A_H10 <= A_H10 + 1;
							end
						default:
							begin
							end
					endcase
				end
		end
	else
		begin
			A_H10 <= 0;
			A_H1 <= 0;
			A_M10 <= 0;
			A_M1 <= 0;
		end
end

endmodule