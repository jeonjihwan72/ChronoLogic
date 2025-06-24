// CHECK_TIME.V

module CHECK_TIME(
	CLK, RESETN,
	H10, H1, M10, M1,
	SA_H10, SA_H1, SA_M10, SA_M1,
	ALARM_TRIGGER
);

input CLK, RESETN;
input [3:0] H10, H1, M10, M1;
input [3:0] SA_H10, SA_H1, SA_M10, SA_M1;

output reg ALARM_TRIGGER;

always @(posedge CLK)
begin
	if((H10==SA_H10)&&(H1==SA_H1)&&(M10==SA_M10)&&(M1==SA_M1))
		ALARM_TRIGGER <= 1'b1;
	else
		ALARM_TRIGGER <= 1'b0;
end

endmodule
