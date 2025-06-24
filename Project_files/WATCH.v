// WATCH.v

module WATCH(
	RESETN, CLK,
	DATA, LCD_E, LCD_RS,
	ALARM_MOD,
	SET_LOC, UP, SET_ALARM,
	SEG_COM, SEG_DATA,
	PIEZO,
	CHAL_BUTTON, CANCEL_BUTTON,
	SEGMENTS,
	MIN_INC, HOUR_INC
);


input RESETN, CLK;
input ALARM_MOD;	// button 1
input MIN_INC, HOUR_INC;

//////////////////////////
///// Character LCD ////// 
//////////////////////////
output LCD_E, LCD_RS;
output [7:0] DATA; 

integer CNT;

reg [6:0] SEC, MIN, HOUR;

reg ALARM;
reg SET_MOD;

wire [3:0] H10, H1, M10, M1, S10, S1;

//////////////////////////
/////// Alarm FND ////////
//////////////////////////
input SET_LOC, UP; // button 6, 5
output [3:0] SEG_COM;
output [7:0] SEG_DATA;
wire [3:0] A_H10, A_H1, A_M10, A_M1;
wire [3:0] SA_H10, SA_H1, SA_M10, SA_M1;

//////////////////////////
///// Alarm Control //////
//////////////////////////
wire DONE_SET;
input SET_ALARM;
wire ALARM_TRIGGER;
wire CANCEL_ALARM;
input CANCEL_BUTTON;

//////////////////////////
///// Piezo Control //////
//////////////////////////
output PIEZO;

//////////////////////////
///// Alarm Disable //////
//////////////////////////
wire DISABLE_TRIGGER;
input CHAL_BUTTON;
wire [3:0] REQ_COUNT;
output wire [6:0] SEGMENTS;

//////////////////////////
///// Time Control ///////
//////////////////////////
reg prev_min_inc, prev_hour_inc;
wire min_inc_pulse, hour_inc_pulse;

always @(posedge CLK or negedge RESETN) begin
	if (!RESETN) begin
		prev_min_inc <= 1;
		prev_hour_inc <= 1;
	end else begin
		prev_min_inc <= MIN_INC;
		prev_hour_inc <= HOUR_INC;
	end
end

assign min_inc_pulse = (prev_min_inc == 1) && (MIN_INC == 0); // falling edge
assign hour_inc_pulse = (prev_hour_inc == 1) && (HOUR_INC == 0);


always @(posedge CLK or negedge RESETN)
begin
	if (~RESETN)
		CNT <= 0;
	else
		begin
			if (CNT >= 999999)
				CNT <= 0;
			else
				CNT <= CNT + 1;
		end
end

always @(posedge CLK or negedge RESETN)
begin
	if (~RESETN)
			SEC <= 0;
	else
		begin
			if (CNT == 999999)
				begin
					if (SEC >= 59)
							SEC <= 0;
					else
						SEC <= SEC + 1;
				end
		end
end

always @(posedge CLK or negedge RESETN) 
begin
	if (~RESETN)
		MIN <= 0;
	else 
		begin
			if (min_inc_pulse) 
				begin
					if (MIN >= 59)
						MIN <= 0;
					else
						MIN <= MIN + 1;
				end 
			else if ((CNT == 999999) && (SEC == 59)) 
				begin
					if (MIN >= 59)
						MIN <= 0;
					else
						MIN <= MIN + 1;
				end
		end
end


always @(posedge CLK or negedge RESETN) begin
	if (~RESETN)
		HOUR <= 0;
	else begin
		if (hour_inc_pulse) begin
			if (HOUR >= 23)
				HOUR <= 0;
			else
				HOUR <= HOUR + 1;
		end else if ((SEC == 59) && (MIN == 59) && (CNT == 999999)) begin
			if (HOUR >= 23)
				HOUR <= 0;
			else
				HOUR <= HOUR + 1;
		end
	end
end


always @(negedge ALARM_MOD or posedge DONE_SET or negedge RESETN or posedge DISABLE_TRIGGER) 
begin
	if (~RESETN || DISABLE_TRIGGER)
		SET_MOD <= 1'b0;
	else if (DONE_SET)
		SET_MOD <= 1'b0;
	else if (~ALARM_MOD)
		SET_MOD <= ~SET_MOD;
end

// alarm trigger control
always @(posedge ALARM_TRIGGER or posedge DISABLE_TRIGGER or negedge RESETN)
begin
	if (~RESETN)
		ALARM <= 1'b0;
	else if (DISABLE_TRIGGER)
		ALARM <= 1'b0;
	else if (ALARM_TRIGGER)
		ALARM <= 1'b1;
end

WATCH_SEP S_SEP(SEC,S10,S1);
WATCH_SEP M_SEP(MIN,M10,M1);
WATCH_SEP H_SEP(HOUR,H10,H1);

WATCH_CLCD_DISP DISP_CLCD(
			CLK, RESETN, DATA, 
			LCD_E, LCD_RS,
			H10, H1, M10, M1, S10, S1, 
			ALARM
			);
									
SET_TIME set_time_inst (
        .CLK(CLK),
        .RESETN(RESETN),
        .BT_UP(UP),
        .BT_LOC(SET_LOC),
        .A_H10(A_H10),
        .A_H1(A_H1),
        .A_M10(A_M10),
        .A_M1(A_M1),
        .ENABLE(SET_MOD)
    );
									
ALARM_FND alarm_fnd_inst (
    .RESETN(RESETN),
    .CLK(CLK),
    .ENABLE(SET_MOD),
    .SEG_COM(SEG_COM),
    .SEG_DATA(SEG_DATA),
    .A_H10(A_H10),
    .A_H1(A_H1),
    .A_M10(A_M10),
    .A_M1(A_M1)
);

PUT_ALARM_SET u_put_alarm_set (
    .RESETN(RESETN),
    .SET_ALARM(SET_ALARM),
    .A_H10(A_H10),
    .A_H1(A_H1),
    .A_M10(A_M10),
    .A_M1(A_M1),
    .ENABLE(SET_MOD),
    .SA_H10(SA_H10),
    .SA_H1(SA_H1),
    .SA_M10(SA_M10),
    .SA_M1(SA_M1),
    .DONE_SET(DONE_SET),
	 .DISABLE_TRIGGER(DISABLE_TRIGGER),
	 .CANCEL(CANCEL_ALARM)
);

CHECK_TIME check_time_inst(
	.CLK(CLK), .RESETN(RESETN),
	.H10(H10), .H1(H1), .M10(M10), .M1(M1),
	.SA_H10(SA_H10), .SA_H1(SA_H1), .SA_M10(SA_M10), .SA_M1(SA_M1),
	.ALARM_TRIGGER(ALARM_TRIGGER)
);

PIEZO_OUT melody_inst (
	.CLK(CLK),
	.RESETN(RESETN),
	.ALARM(ALARM),
	.PIEZO(PIEZO)
);

ALARM_DISABLE alarm_disable_inst(
	.RESETN(RESETN),
	.ALARM(ALARM),
	.CHAL_BUTTON(CHAL_BUTTON),
	.COMPLETE(DISABLE_TRIGGER),
	.required_count(REQ_COUNT)
);

DISP_REMAIN_COUNT disp_remain_count_inst(
	.CLK(CLK),
	.digit(REQ_COUNT),
	.ALARM(ALARM),
	.segments(SEGMENTS)
);

CANCEL_ALARM cancel_alarm_inst(
	.RESETN(RESETN), .ALARM(ALARM),
	.CANCEL_BUTTON(CANCEL_BUTTON),
	.CANCEL(CANCEL_ALARM)
);

endmodule