`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2016 11:23:37 AM
// Design Name: 
// Module Name: ti_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top(
    input logic CLK100MHZ, CPU_RESETN,
    input logic [1:0] SW,
    output logic AUD_PWM, AUD_SD
);
    assign AUD_SD = 1'b1;
    
    logic nWE, nCE;
    logic CLK;
    logic [7:0] D;
    logic READY;
    
    logic [4:0] divider;
    logic [15:0] music_unit;
    logic [24:0] music_ctr;
    logic latch;
    logic tone_latch;
    
    ti_top ti(.nWE(nWE), .nCE(nCE), .CLK(CLK), .nRST(CPU_RESETN), .D(D), .READY(READY), .AOUT(AUD_PWM));
    
    enum logic [2:0] {
        START, IDLE, SET_TONE_1, WAIT_1_PWM, WAIT_2_PWM, SET_VOLUME_1,
        SET_TONE_2, SET_VOLUME_2
    } state, nextState;
    
    
    always_ff @(posedge CLK100MHZ, negedge CPU_RESETN) begin
        if(!CPU_RESETN) begin
            CLK <= 0;
            divider <= 0;
            music_unit <= 0;
            music_ctr <= 0;
            state <= START;
            latch <= 1;
            tone_latch <= 0;
         end
         else begin
            state <= nextState;
            if (divider == 13) begin
                divider <= 0;
                CLK <= ~CLK;
            end
            else begin
                divider <= divider + 1;
            end
            if (music_ctr == 25'd20000000) begin
                music_ctr <= 0;
                if (music_unit == 63) begin
                    music_unit <= 0;
                end
                else begin
                    music_unit <= music_unit + 1;
                end
            end
            else begin
                music_ctr <= music_ctr + 1;
            end
            case (state)
                START: begin
                                     
                end
                SET_TONE_1: begin
                    if (latch) begin
                        if (music_unit == 0 || // E
                            music_unit == 1 ||
                            music_unit == 12 ||
                            music_unit == 13 ||
                            music_unit == 22 ||
                            music_unit == 23 ||
                            music_unit == 40 ||
                            music_unit == 41 ||
                            music_unit == 42 ||
                            music_unit == 44 ||
                            music_unit == 45 ||
                            music_unit == 54 ||
                            music_unit == 55) begin
                            D <= 8'b10001010;
                        end
                        else if (music_unit == 2 || // B
                                 music_unit == 7 ||
                                 music_unit == 16 ||
                                 music_unit == 17 ||
                                 music_unit == 48 ||
                                 music_unit == 50) begin
                            D <= 8'b10000010;
                        end
                        else if (music_unit == 3 ||
                                 music_unit == 6 ||
                                 music_unit == 11 ||
                                 music_unit == 15 ||
                                 music_unit == 19 ||
                                 music_unit == 24 ||
                                 music_unit == 25 ||
                                 music_unit == 43 ||
                                 music_unit == 47 ||
                                 music_unit == 51 ||
                                 music_unit == 56 ||
                                 music_unit == 57) // C
                        begin
                            D <= 8'b10000110;
                        end
                        else if (music_unit == 4 || // D
                                 music_unit == 5 ||
                                 music_unit == 14 ||
                                 music_unit == 20 ||
                                 music_unit == 21 ||
                                 music_unit == 33 ||
                                 music_unit == 34 ||
                                 music_unit == 46 ||
                                 music_unit == 52 ||
                                 music_unit == 53) begin
                            D <= 8'b10001110;     
                        end
                        else if (music_unit == 8 ||
                                 music_unit == 10 ||
                                 music_unit == 26 ||
                                 music_unit == 28 ||
                                 music_unit == 29 ||
                                 music_unit == 30 ||
                                 music_unit == 31 ||
                                 music_unit == 58 ||
                                 music_unit == 60 ||
                                 music_unit == 61 ||
                                 music_unit == 62 ||
                                 music_unit == 63) // A4
                        begin
                            D <= 8'b10001110;
                        end
                        else if (music_unit == 36 ||
                                 music_unit == 37) // A5
                        begin
                            D <= 8'b10001111;
                        end
                        else if (music_unit == 35 ||
                                 music_unit == 39) begin //F
                            D <= 8'b10000000;
                        end
                        else if (music_unit == 38) begin // G5
                            D <= 8'b10001111;
                        end
                        else begin
                            D <= 8'b10001111;
                        end
                    end
                    else begin
                        if (music_unit == 0 || // E
                            music_unit == 1 ||
                            music_unit == 12 ||
                            music_unit == 13 ||
                            music_unit == 22 ||
                            music_unit == 23 ||
                            music_unit == 40 ||
                            music_unit == 41 ||
                            music_unit == 42 ||
                            music_unit == 44 ||
                            music_unit == 45 ||
                            music_unit == 54 ||
                            music_unit == 55) begin
                            D <= 8'b00001010;
                        end
                        else if (music_unit == 2 || // B
                                 music_unit == 7 ||
                                 music_unit == 16 ||
                                 music_unit == 17 ||
                                 music_unit == 48 ||
                                 music_unit == 50) begin
                            D <= 8'b00001110;
                        end 
                        else if (music_unit == 3 ||
                                 music_unit == 6 ||
                                 music_unit == 11 ||
                                 music_unit == 15 ||
                                 music_unit == 19 ||
                                 music_unit == 24 ||
                                 music_unit == 25 ||
                                 music_unit == 43 ||
                                 music_unit == 47 ||
                                 music_unit == 51 ||
                                 music_unit == 56 ||
                                 music_unit == 57) // C 
                        begin
                            D <= 8'b00001101;
                        end
                        else if (music_unit == 4 || // D
                                 music_unit == 5 ||
                                 music_unit == 14 ||
                                 music_unit == 20 ||
                                 music_unit == 21 ||
                                 music_unit == 33 ||
                                 music_unit == 34 ||
                                 music_unit == 46 ||
                                 music_unit == 52 ||
                                 music_unit == 53) begin
                            D <= 8'b00001011;     
                        end
                        else if (music_unit == 8 ||
                                 music_unit == 10 ||
                                 music_unit == 26 ||
                                 music_unit == 28 ||
                                 music_unit == 29 ||
                                 music_unit == 30 ||
                                 music_unit == 31 ||
                                 music_unit == 58 ||
                                 music_unit == 60 ||
                                 music_unit == 61 ||
                                 music_unit == 62 ||
                                 music_unit == 63) // A4
                        begin
                            D <= 8'b00001111;
                        end
                        else if (music_unit == 38) begin // G5
                            D <= 8'b000001000;
                        end
                        else if (music_unit == 36 ||
                                 music_unit == 37) // A5
                        begin
                            D <= 8'b00000111;
                        end
                        else if (music_unit == 35 ||
                                 music_unit == 39) begin //F
                            D <= 8'b00001010;
                        end
                        else begin
                            D <= 8'b00111111;
                        end
                    end
                end
                SET_VOLUME_1: begin 
                    if (SW[0]) begin
                        D <= 8'b10011111;
                    end
                    else begin
                        D <= 8'b10010000; //1001 1
                    end
                    tone_latch <= ~tone_latch;
                end
                
                SET_TONE_2: begin
                    if (latch) begin
                        if (music_unit == 1 || // E
                            music_unit == 3 ||
                            music_unit == 5 ||
                            music_unit == 7 ||
                            music_unit == 21 ||
                            music_unit == 23 ||
                            music_unit == 53 ||
                            music_unit == 57 ||
                            music_unit == 59) begin
                            D <= 8'b10100111;
                        end
                        else if (music_unit == 9 || // A
                                 music_unit == 11 ||
                                 music_unit == 13 ||
                                 music_unit == 15 ||
                                 music_unit == 25 ||
                                 music_unit == 27 ||
                                 music_unit == 29 ||
                                 music_unit == 31) begin
                            D <= 8'b10101100;
                        end
                        else if (music_unit == 17 ||
                                 music_unit == 19 ||
                                 music_unit == 55) begin // G#
                            D <= 8'b10101011;
                        end
                        else if (music_unit == 33 ||
                                 music_unit == 35 ||
                                 music_unit == 37 ||
                                 music_unit == 39) begin // D
                            D <= 8'b10101010;     
                        end
                        else if (music_unit == 41 ||
                                 music_unit == 43 ||
                                 music_unit == 45 ||
                                 music_unit == 47) begin // C
                            D <= 8'b10100111;         
                        end
                        else if (music_unit == 49 ||
                                 music_unit == 51) begin // B
                            D <= 8'b10100101;      
                        end
                        else begin
                            D <= 8'b10101111;
                        end
                    end
                    else begin
                        if (music_unit == 1 || // E
                            music_unit == 3 ||
                            music_unit == 5 ||
                            music_unit == 7 ||
                            music_unit == 21 ||
                            music_unit == 23 ||
                            music_unit == 53 ||
                            music_unit == 57 ||
                            music_unit == 59) begin
                            D <= 8'b00101010;
                        end
                        else if (music_unit == 9 || // A
                                 music_unit == 11 ||
                                 music_unit == 13 ||
                                 music_unit == 15 ||
                                 music_unit == 25 ||
                                 music_unit == 27 ||
                                 music_unit == 29) begin
                            D <= 8'b00011111;
                        end
                        else if (music_unit == 17 ||
                                 music_unit == 19 ||
                                 music_unit == 55) begin // G#
                            D <= 8'b00100001;
                        end
                        else if (music_unit == 33 ||
                                 music_unit == 35 ||
                                 music_unit == 37 ||
                                 music_unit == 39) begin // D
                            D <= 8'b00101111;     
                        end
                        else if (music_unit == 41 ||
                                 music_unit == 43 ||
                                 music_unit == 45 ||
                                 music_unit == 47) begin // C
                            D <= 8'b00110101;         
                        end
                        else if (music_unit == 49 ||
                                 music_unit == 51) begin // B
                            D <= 8'b00011100;      
                        end
                        else begin
                            D <= 8'b00111111;
                        end
                    end
                end
                SET_VOLUME_2: begin
                    if (SW[0]) begin
                        D <= 8'b10111111;
                    end
                    else begin
                        D <= 8'b10111000;
                    end
                    tone_latch <= ~tone_latch;
                end
                WAIT_1_PWM: begin
                         
                end
                WAIT_2_PWM: begin
                    if (D[7] == 1) begin
                        latch <= D[4];
                    end
                            
                            
                //latch remains 0 at the end of the second SET TONE
                //latch is a 1 at the end of SET VOLUME
                end
                default: begin
                    D <= 0;
                    latch <= 0;
                end
            endcase
        end
    end
    
    always_comb begin
        case (state)
            START: begin
                nextState = SET_TONE_1; 
                nWE = 1;
                nCE = 1;
            end
            SET_TONE_1: begin
                nextState = WAIT_1_PWM;
            end
            SET_VOLUME_1: begin   
                nextState = WAIT_1_PWM;     
            end
            SET_TONE_2: begin
                nextState = WAIT_1_PWM;
            end
            SET_VOLUME_2: begin   
                nextState = WAIT_1_PWM;     
            end
            WAIT_1_PWM: begin
                nWE = 0;
                nCE = 0;
                if(READY) begin
                    nextState = WAIT_1_PWM;
                end
                else begin
                    nextState = WAIT_2_PWM;
                end
            end
            WAIT_2_PWM: begin
                nWE = 1;
                nCE = 1;
                if (tone_latch) begin
                    nextState = READY ? ((!D[7]) ? SET_VOLUME_1 : SET_TONE_1) : WAIT_2_PWM;
                end
                else begin
                    nextState = READY ? ((!D[7]) ? SET_VOLUME_2 : SET_TONE_2) : WAIT_2_PWM;
                end
            end
        endcase
    end
    
endmodule