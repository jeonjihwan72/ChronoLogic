module PIEZO_OUT (
    input CLK,
    input RESETN,
    input ALARM,
    output reg PIEZO
);

parameter G3 = 1204;
parameter A3 = 1073;
parameter B3 = 1012;
parameter C4 = 902;
parameter D4 = 804;
parameter E4 = 716;
parameter F4 = 676;
parameter G4 = 602;
parameter SILENT = 0;

reg [15:0] melody [0:36];
initial begin
    melody[0]  = C4;
	 melody[1]  = C4;
    melody[2]  = F4;
    melody[3]  = E4;
    melody[4]  = D4;
    melody[5]  = C4;
	 melody[6]  = C4;
    melody[7]  = A3;
	 melody[8]  = A3;
    melody[9]  = B3;
    melody[10]  = C4;
    melody[11]  = D4;
    melody[12]  = G3;
    melody[13] = A3;
    melody[14] = B3;
    melody[15] = A3;
	 melody[16] = A3;
    melody[17] = C4;
    melody[18] = SILENT;
    melody[19] = C4;
	 melody[20] = C4;
    melody[21] = F4;
    melody[22] = E4;
    melody[23] = D4;
    melody[24] = C4;
	 melody[25] = C4;
    melody[26] = F4;
	 melody[27] = F4;
    melody[28] = F4;
    melody[29] = G4;
    melody[30] = F4;
    melody[31] = E4;
    melody[32] = D4;
    melody[33] = E4;
    melody[34] = F4;
	 melody[35] = F4;
	 melody[36] = SILENT;
end


parameter NOTE_LENGTH = 150_000;

reg [5:0] note_index = 0;
reg [31:0] tone_counter = 0;
reg [31:0] duration_counter = 0;
reg [15:0] current_div = E4;
reg prev_alarm = 0;

always @(posedge CLK or negedge RESETN) begin
    if (~RESETN) begin
        PIEZO <= 0;
        tone_counter <= 0;
        duration_counter <= 0;
        note_index <= 0;
        current_div <= E4;
        prev_alarm <= 0;
    end else begin
        if (ALARM && !prev_alarm) begin
            note_index <= 0;
            tone_counter <= 0;
            duration_counter <= 0;
            current_div <= melody[0];
        end
        prev_alarm <= ALARM;

        if (ALARM) begin
            if (duration_counter < NOTE_LENGTH) begin
                duration_counter <= duration_counter + 1;
            end else begin
                duration_counter <= 0;
                tone_counter <= 0;
                note_index <= (note_index == 36) ? 0 : note_index + 1;
                current_div <= melody[note_index];
            end

            if (current_div != 0) begin
                if (tone_counter < current_div)
                    tone_counter <= tone_counter + 1;
                else begin
                    tone_counter <= 0;
                    PIEZO <= ~PIEZO;
                end
            end else begin
                PIEZO <= 0;
            end
        end else begin
            PIEZO <= 0;
            tone_counter <= 0;
            duration_counter <= 0;
            note_index <= 0;
            current_div <= E4;
        end
    end
end

endmodule

