// PUT_ALARM_SET

module PUT_ALARM_SET(
	ENABLE, RESETN,
	SET_ALARM,
	A_H10, A_H1, A_M10, A_M1,
	SA_H10, SA_H1, SA_M10, SA_M1,
	DONE_SET,
	DISABLE_TRIGGER,
	CANCEL
);

input ENABLE, RESETN;
input SET_ALARM;
input [3:0] A_H10, A_H1, A_M10, A_M1;
input DISABLE_TRIGGER, CANCEL;

output reg [3:0] SA_H10, SA_H1, SA_M10, SA_M1;
output reg DONE_SET;

always @(negedge SET_ALARM or negedge RESETN or posedge DISABLE_TRIGGER or posedge CANCEL)
begin
	if(~RESETN || DISABLE_TRIGGER || CANCEL)
		begin
			SA_H10 <= 4'hF;
			SA_H1 <= 4'hF;
			SA_M10 <= 4'hF;
			SA_M1 <= 4'hF;
			DONE_SET <= 1'b0;
		end
	else if(~SET_ALARM && ENABLE)
		begin
			SA_H10 <= A_H10;
			SA_H1 <= A_H1;
			SA_M10 <= A_M10;
			SA_M1 <= A_M1;
			DONE_SET <= 1'b1;
		end
end

endmodule