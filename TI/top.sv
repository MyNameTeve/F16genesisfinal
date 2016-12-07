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
    input logic [15:0] SW,
    output logic AUD_PWM, 
    output logic [1:0] JA
);
    /*
    logic CLK100MHZ, CPU_RESETN;
    logic [15:0] SW;
    logic AUD_PWM;
    */
    assign JA[1] = AUD_PWM;
    assign JA[0] = 1'b1;
    
    logic nWE, nCE;
    logic CLK;
    logic [7:0] D;
    logic READY, AOUT;
    
    logic [4:0] divider;
    logic [15:0] music_unit;
    logic [24:0] music_ctr;
    logic latch;
    
    ti_top ti(.nWE, .nCE, .CLK, .nRST(CPU_RESETN), .D, .READY, .AOUT(AUD_PWM));
    
    enum logic [2:0] {
        START, IDLE, SET_TONE_1, WAIT_1_PWM, WAIT_2_PWM, SET_VOLUME_1
    } state, nextState;
    
    always_ff @(posedge CLK100MHZ, negedge CPU_RESETN) begin
        if (~CPU_RESETN) begin
            CLK <= 0;
            divider <= 0;
            music_unit <= 0;
            music_ctr <= 0;
            nWE <= 1;
            nCE <= 1;
            state <= START;
            latch <= 1;
        end
        else begin
            nWE <= 0;
            nCE <= 0;
            state <= nextState;
            if (divider == 27) begin
                divider <= 0;
                CLK <= 1;
            end
            else begin
                CLK <= 0;
                divider <= divider + 1;
            end
            if (music_ctr == 2500000) begin
                music_ctr <= 0;
                music_unit = music_unit + 1;
            end
            else begin
                music_ctr <= music_ctr + 1;
            end
        end
    end
    
    always_comb begin
        case (state)
            START: begin
                nextState = SET_TONE_1;
            end
            SET_TONE_1: begin
                nextState = WAIT_1_PWM;
            end
            SET_VOLUME_1: begin
                nextState = WAIT_1_PWM;        
            end
            WAIT_1_PWM: begin
                if (divider == 27) begin
                    nextState = WAIT_2_PWM;
                end
                else begin
                    nextState = WAIT_1_PWM;
                end
            end
            WAIT_2_PWM: begin
                if (divider == 27) begin
                    nextState = (~D[7]) ? SET_VOLUME_1 : SET_TONE_1;
                end
                else begin
                    nextState = WAIT_2_PWM;
                end
            end
            default: nextState = START;
        endcase
    end
    
    always_ff @(posedge CLK100MHZ) begin
        case (state)
            START: begin
            
            end
            SET_TONE_1: begin
                if (latch) begin
                    D <= 8'b10001001;
                end
                else begin
                    D <= 8'b00111111;
                end
            end
            SET_VOLUME_1: begin
                D <= 8'b10010000;
            end
            WAIT_1_PWM: begin
            end
            WAIT_2_PWM: begin
                if (D[7] == 1) begin
                    latch <= D[4];
                end
            end
            default: begin
                D <= 0;
                latch <= 0;
            end
        endcase
    end
    /*
    initial begin
        CLK100MHZ <= 0;
        forever #5 CLK100MHZ <= ~CLK100MHZ;
    end
    
    initial begin
        CPU_RESETN <= 1;
        @(posedge CLK100MHZ);
        CPU_RESETN <= 0;
        @(posedge CLK100MHZ);
        CPU_RESETN <= 1;
        @(posedge CLK100MHZ);
    end
    */
endmodule