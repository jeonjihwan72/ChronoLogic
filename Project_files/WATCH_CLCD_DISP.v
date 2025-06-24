//WATCH_CLCD_DISP.v

module WATCH_CLCD_DISP(
    CLK, RESETN,
	 DATA,LCD_E, LCD_RS,
	 H10, H1, M10, M1, S10, S1,
	 ALARM
);

input CLK;
input RESETN;
input [3:0] H10, H1;
input [3:0] M10, M1;
input [3:0] S10, S1;
input ALARM;

output [7:0] DATA;
output LCD_E;
output LCD_RS;

reg [7:0] DATA;
reg LCD_E;
reg LCD_RS;

reg [7:0] DISPDATA [0:37];
reg [7:0] ASCII_H10, ASCII_H1;
reg [7:0] ASCII_M10, ASCII_M1;
reg [7:0] ASCII_S10, ASCII_S1;

integer i = 0;
integer j = 0;

parameter COLON = 8'h3A, SPACE = 8'h20;
parameter CHAR_T = 8'h54, CHAR_I = 8'h49, CHAR_E = 8'h45, CHAR_M = 8'h4D,
			CHAR_S = 8'h53, CHAR_O = 8'h4F, CHAR_V = 8'h56, CHAR_R = 8'h52;

always @(*) 
begin
    case (H10)
        4'd0: ASCII_H10 = 8'h30; // '0'
        4'd1: ASCII_H10 = 8'h31; // '1'
        4'd2: ASCII_H10 = 8'h32; // '2'
        4'd3: ASCII_H10 = 8'h33; // '3'
        4'd4: ASCII_H10 = 8'h34; // '4'
        4'd5: ASCII_H10 = 8'h35; // '5'
        4'd6: ASCII_H10 = 8'h36; // '6'
        4'd7: ASCII_H10 = 8'h37; // '7'
        4'd8: ASCII_H10 = 8'h38; // '8'
        4'd9: ASCII_H10 = 8'h39; // '9'
        default: ASCII_H10 = 8'h20; // 공백
    endcase
	 
	 case (H1)
        4'd0: ASCII_H1 = 8'h30; // '0'
        4'd1: ASCII_H1 = 8'h31; // '1'
        4'd2: ASCII_H1 = 8'h32; // '2'
        4'd3: ASCII_H1 = 8'h33; // '3'
        4'd4: ASCII_H1 = 8'h34; // '4'
        4'd5: ASCII_H1 = 8'h35; // '5'
        4'd6: ASCII_H1 = 8'h36; // '6'
        4'd7: ASCII_H1 = 8'h37; // '7'
        4'd8: ASCII_H1 = 8'h38; // '8'
        4'd9: ASCII_H1 = 8'h39; // '9'
        default: ASCII_H1 = 8'h20; // 공백
    endcase
	 
	 case (M10)
        4'd0: ASCII_M10 = 8'h30; // '0'
        4'd1: ASCII_M10 = 8'h31; // '1'
        4'd2: ASCII_M10 = 8'h32; // '2'
        4'd3: ASCII_M10 = 8'h33; // '3'
        4'd4: ASCII_M10 = 8'h34; // '4'
        4'd5: ASCII_M10 = 8'h35; // '5'
        4'd6: ASCII_M10 = 8'h36; // '6'
        4'd7: ASCII_M10 = 8'h37; // '7'
        4'd8: ASCII_M10 = 8'h38; // '8'
        4'd9: ASCII_M10 = 8'h39; // '9'
        default: ASCII_M10 = 8'h20; // 공백
    endcase
	 
	 case (M1)
        4'd0: ASCII_M1 = 8'h30; // '0'
        4'd1: ASCII_M1 = 8'h31; // '1'
        4'd2: ASCII_M1 = 8'h32; // '2'
        4'd3: ASCII_M1 = 8'h33; // '3'
        4'd4: ASCII_M1 = 8'h34; // '4'
        4'd5: ASCII_M1 = 8'h35; // '5'
        4'd6: ASCII_M1 = 8'h36; // '6'
        4'd7: ASCII_M1 = 8'h37; // '7'
        4'd8: ASCII_M1 = 8'h38; // '8'
        4'd9: ASCII_M1 = 8'h39; // '9'
        default: ASCII_M1 = 8'h20; // 공백
    endcase
	 
	 case (S10)
        4'd0: ASCII_S10 = 8'h30; // '0'
        4'd1: ASCII_S10 = 8'h31; // '1'
        4'd2: ASCII_S10 = 8'h32; // '2'
        4'd3: ASCII_S10 = 8'h33; // '3'
        4'd4: ASCII_S10 = 8'h34; // '4'
        4'd5: ASCII_S10 = 8'h35; // '5'
        4'd6: ASCII_S10 = 8'h36; // '6'
        4'd7: ASCII_S10 = 8'h37; // '7'
        4'd8: ASCII_S10 = 8'h38; // '8'
        4'd9: ASCII_S10 = 8'h39; // '9'
        default: ASCII_S10 = 8'h20; // 공백
    endcase
	 
	 case (S1)
        4'd0: ASCII_S1 = 8'h30; // '0'
        4'd1: ASCII_S1 = 8'h31; // '1'
        4'd2: ASCII_S1 = 8'h32; // '2'
        4'd3: ASCII_S1 = 8'h33; // '3'
        4'd4: ASCII_S1 = 8'h34; // '4'
        4'd5: ASCII_S1 = 8'h35; // '5'
        4'd6: ASCII_S1 = 8'h36; // '6'
        4'd7: ASCII_S1 = 8'h37; // '7'
        4'd8: ASCII_S1 = 8'h38; // '8'
        4'd9: ASCII_S1 = 8'h39; // '9'
        default: ASCII_S1 = 8'h20; // 공백
    endcase
end

always @(posedge CLK or negedge RESETN)
begin
    if (~RESETN)
    begin
        //LCD init
        DISPDATA[0] <= 8'h38;
        DISPDATA[1] <= 8'h0f;
        DISPDATA[2] <= 8'h06;
        DISPDATA[3] <= 8'h01;
        DISPDATA[4] <= 8'h80;  // first line
        
        DISPDATA[5] <= SPACE; // start to first line
        DISPDATA[6] <= SPACE;
        DISPDATA[7] <= 8'h30;  // '0'
        DISPDATA[8] <= 8'h30;  // '0'
        DISPDATA[9] <= SPACE;
        DISPDATA[10] <= COLON;
        DISPDATA[11] <= SPACE;
        DISPDATA[12] <= 8'h30; // '0'
        DISPDATA[13] <= 8'h30; // '0'
        DISPDATA[14] <= SPACE;
        DISPDATA[15] <= COLON;
        DISPDATA[16] <= SPACE;
        DISPDATA[17] <= 8'h30; // '0'
        DISPDATA[18] <= 8'h30; // '0'처리
        DISPDATA[19] <= SPACE;
        DISPDATA[20] <= SPACE;
		  
        DISPDATA[21] <= 8'hC0;  // second line
        for (i = 22; i <= 37; i = i + 1) // second line filled with SPACE
            DISPDATA[i] <= SPACE;
        
        i <= 0;
        j <= 0;
    end
    else
    begin
        // 시간 ASCII 값으로 DISPDATA
        DISPDATA[7]  <= ASCII_H10;
        DISPDATA[8] <= ASCII_H1;
        DISPDATA[12] <= ASCII_M10;
        DISPDATA[13] <= ASCII_M1;
        DISPDATA[17] <= ASCII_S10;
        DISPDATA[18] <= ASCII_S1;
		  
		  // ALARM이 1일 때 두 번째 줄에 "TIME IS OVER" 출력
		  if (ALARM)
        begin
            DISPDATA[22] <= SPACE;
            DISPDATA[23] <= SPACE;
            DISPDATA[24] <= CHAR_T;
            DISPDATA[25] <= CHAR_I;
            DISPDATA[26] <= CHAR_M;
            DISPDATA[27] <= CHAR_E;
            DISPDATA[28] <= SPACE;
            DISPDATA[29] <= CHAR_I;
            DISPDATA[30] <= CHAR_S;
            DISPDATA[31] <= SPACE;
            DISPDATA[32] <= CHAR_O;
            DISPDATA[33] <= CHAR_V;
            DISPDATA[34] <= CHAR_E;
            DISPDATA[35] <= CHAR_R;
            DISPDATA[36] <= SPACE;
            DISPDATA[37] <= SPACE;
        end
		  else
		  begin
				DISPDATA[22] <= SPACE;
            DISPDATA[23] <= SPACE;
            DISPDATA[24] <= SPACE;
            DISPDATA[25] <= SPACE;
            DISPDATA[26] <= SPACE;
            DISPDATA[27] <= SPACE;
            DISPDATA[28] <= SPACE;
            DISPDATA[29] <= SPACE;
            DISPDATA[30] <= SPACE;
            DISPDATA[31] <= SPACE;
            DISPDATA[32] <= SPACE;
            DISPDATA[33] <= SPACE;
            DISPDATA[34] <= SPACE;
            DISPDATA[35] <= SPACE;
            DISPDATA[36] <= SPACE;
            DISPDATA[37] <= SPACE;
		  end
		  
        // LCD 데이터 출력 및 제어 신호 처리 (기존 코드 유지)
        if(i <= 20000)
        begin
            i <= i + 1;
            LCD_E <= 1;
            DATA <= DISPDATA[j];
        end
        else if (i > 20000 && i < 40000)
        begin
            i <= i + 1;
            LCD_E <= 0;
        end
        else if (i == 40000)
        begin
            j <= j + 1;
            i <= 0;
        end

        if (j <= 4)
            LCD_RS <= 0;
        else if (j > 4 && j < 21)
            LCD_RS <= 1;
        else if (j == 21)
            LCD_RS <= 0;
        else if (j > 21 && j < 38)
            LCD_RS <= 1;

        if (j == 38)
            j <= 4;
    end
end


endmodule
