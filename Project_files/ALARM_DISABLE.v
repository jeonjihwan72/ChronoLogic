// ALARM_DISABLE.v

module ALARM_DISABLE (
    input wire RESETN,
    input wire ALARM,
    input wire CHAL_BUTTON,
    output reg COMPLETE,
    output reg [3:0] required_count
);

always @(negedge RESETN or negedge CHAL_BUTTON) begin
   if (~RESETN) begin
       required_count <= 4'd0;
       COMPLETE <= 1'b0;
   end
   else if (~CHAL_BUTTON) 
	begin
		if (ALARM)
			begin
				if (required_count == 9)
					begin
						COMPLETE <= 1'b1;
						required_count <= 1'b0;
					end
				else
					COMPLETE <= 1'b0;
					required_count <= required_count + 1;
			end
		else
			COMPLETE <= 1'b0;
	end
end

endmodule

