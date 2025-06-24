// CANCEL_ALARM.v

module CANCEL_ALARM(
	input RESETN, ALARM,
	input CANCEL_BUTTON,
	output reg CANCEL
);

always @(negedge RESETN or negedge CANCEL_BUTTON)
begin
	if (~RESETN)
		CANCEL <= 1'b0;
	else
		begin
			if (~ALARM)
				CANCEL <= ~CANCEL;
		end
end

endmodule
