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
    input logic BTNC,
    output logic AUD_PWM, 
    output logic AUD_SD,
    output logic [1:0] JA,
    output logic [10:0] LED
);
    
    /*logic CLK100MHZ, CPU_RESETN;
    logic [15:0] SW;
    logic AUD_PWM;
    logic BTNC;
    logic [10:0] LED;*/
    
    
    assign JA[1] = AUD_PWM;
    assign JA[0] = 1'b1;
    assign AUD_SD = 1'b1;
    
    assign LED[9:0] = tone0;
    
    logic nWE, nCE;
    logic CLK;
    logic [7:0] D;
    logic READY;
    
    logic [4:0] divider;
    logic [15:0] music_unit;
    logic [24:0] music_ctr;
    logic latch;
    logic [9:0] tone0;
    
    ti_top ti(.nWE(nWE), .nCE(nCE), .CLK(CLK), .nRST(CPU_RESETN), .D(D), .READY(READY), .AOUT(AUD_PWM), .tone0(tone0));
    
    (* mark_debug = "true" *)
    enum logic [2:0] {
        START, IDLE, SET_TONE_1, WAIT_1_PWM, WAIT_2_PWM, SET_VOLUME_1
    } state, nextState;
    
    
    always_ff @(posedge CLK100MHZ, negedge CPU_RESETN) begin
        if(!CPU_RESETN) begin
            CLK <= 0;
            divider <= 0;
            music_unit <= 0;
            music_ctr <= 0;
            state <= START;
            latch <= 1;
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
            if (music_ctr == 2500000) begin
                music_ctr <= 0;
                music_unit = music_unit + 1;
            end
            else begin
                music_ctr <= music_ctr + 1;
            end
            case (state)
                START: begin
                                     
                end
                SET_TONE_1: begin    
                    if (latch) begin
                       if(BTNC) begin
                            D <= 8'b10001001; //    1111111001 0x3F9 1017  0110100101
                            LED[10] <= 1'b1;
                       end
                       else begin
                            D <= 8'b10000101; //    0001010101 0x55 85     0110101001
                            LED[10] <= 1'b0;
                       end
                    end
                    else begin
                        if(BTNC) begin
                            D <= 8'b00111111;
                            LED[10] <= 1'b1;
                        end
                        else begin
                            D <= 8'b00000101;
                            LED[10] <= 1'b0;
                        end
                    end
                end
                SET_VOLUME_1: begin
                       
                    D <= 8'b10010001; //1001 1
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
                nextState = READY ? ((!D[7]) ? SET_VOLUME_1 : SET_TONE_1) : WAIT_2_PWM;
            end
        endcase
    end
    
    /*initial begin
        CLK100MHZ <= 0;
        forever #5 CLK100MHZ <= ~CLK100MHZ;
    end
    
    initial begin
        CPU_RESETN <= 1;
        @(posedge CLK100MHZ);
        CPU_RESETN <= 0;
        BTNC <= 1;
        @(posedge CLK100MHZ);
        CPU_RESETN <= 1;
        @(posedge CLK100MHZ);
        #15000000 BTNC <= 1'b0;
    end*/
    
endmodule