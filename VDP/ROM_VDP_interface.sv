`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2016 02:34:19 PM
// Design Name: 
// Module Name: ROM_VDP_interface
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





module ROM_VDP_interface(
    input logic clk, srst_n,
    input logic [15:0] VDP_DO, //likely don't need this but whatever
    input logic [21:0] ROM_dout,
    input logic VDP_DTACK_N,
    output logic ROM_ena,
    output logic [11:0]ROM_addr,
    output logic [15:0] VDP_DI, //
    output logic [4:0] VDP_A, //connects to VDP_A
    output logic VDP_RNW,
    output logic VDP_SEL);
    
    
    logic [11:0] ROM_ADDR; //this will be different
    logic [21:0] ROM_DATA;
    logic ROM_EN;
    
    assign ROM_DATA = ROM_dout;
    assign ROM_addr = ROM_ADDR;
    assign ROM_ena = ROM_EN;
    
    
    //logic VDP_RST_N, VDP_CLK, VDP_SEL, VDP_RNW, VDP_DTACK_N;
    
    enum logic [1:0] {RESET, ROM_READ, VDP_WRITE, WAIT} state;
    //likely need more for some sort of startup
    
    always_ff @(posedge clk) begin
        if(!srst_n) begin
            state <= RESET;
        end
        if(state == RESET) begin
            state <= ROM_READ;
            ROM_ADDR <= 16'd0;
            ROM_EN <= 1'b1;
        end
        if(state == ROM_READ) begin
            state <= VDP_WRITE;
            VDP_DI <= ROM_DATA[15:0];
            VDP_A <= ROM_DATA[20:16];
            VDP_RNW <= ROM_DATA[21];
            VDP_SEL <= 1'b1;
            ROM_EN <= 1'b0;
        end
        if(state==VDP_WRITE) begin
            state<=WAIT;
            ROM_ADDR <= ROM_ADDR + 1;
        end
        if(state==WAIT) begin
            if(!VDP_DTACK_N) begin
                state <= ROM_READ;
                ROM_EN <= 1'b1;
                VDP_SEL <= 1'b0;
            end
            else begin
                state <= WAIT;
            end
        end    
    end    
    
endmodule
