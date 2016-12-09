`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2016 11:07:23 AM
// Design Name: 
// Module Name: vdp_tb
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
module vdp_tb(
    input logic CLK100MHZ, CPURESET_N, 
    output logic [3:0] VGA_R, VGA_B, VGA_G,
    output logic VGA_HS, VGA_VS);
    
    logic RST_N, CLK;
    assign RST_N = CPURESET_N;
    assign CLK = CLK100MHZ;
    //comment if synth
    
    //logic [3:0] VGA_R, VGA_G, VGA_B;
    
    logic SEL, RNW, UDS_N, LDS_N, VRAM_DTACK_N, INTERLACE, HINT_ACK,
                    VINT_TG68_ACK, VINT_T80_ACK, VBUS_DMA_ACK,VBUS_DTACK_N;
    logic [4:0] A;
    logic [15:0] DI, VBUS_DATA, DO, VRAM_DI, VRAM_DO;
    logic DTACK_N, VRAM_CE_N, VRAM_UB_N, VRAM_LB_N, VRAM_OE_N, VRAM_WE_N, VRAM_SEL, 
                    HINT, VINT_TG68, VINT_T80, VBUS_DMA_REQ, VBUS_UDS_N, VBUS_LDS_N,
                    VBUS_SEL, VGA_HS, VGA_VS;   
    logic [14:0] VRAM_ADDR;
    logic [23:0] VBUS_ADDR;
              
    
    
    logic ROM_ena;
    logic [11:0] ROM_addr;
    logic [21:0] ROM_dout;
    
    blk_mem_gen_1 VRAM (.addra({VRAM_ADDR, 1'b0}), .clka(CLK), .dina(VRAM_DI[15:8]), .douta(VRAM_DO[15:8]), .ena(~VRAM_UB_N && ~VRAM_CE_N), .wea(~VRAM_WE_N),
                         .addrb({VRAM_ADDR, 1'b1}), .clkb(CLK), .dinb(VRAM_DI[7:0]), .doutb(VRAM_DO[7:0]), .enb(~VRAM_LB_N && ~VRAM_CE_N), .web(~VRAM_WE_N));
    
    blk_mem_gen_0 ROM (.clka(CLK), .ena(ROM_ena), .douta(ROM_dout), .addra(ROM_addr));
     
    ROM_VDP_interface inter( .clk(CLK), .srst_n(RST_N),
    .VDP_DO(DO), .ROM_dout(ROM_dout), .ROM_ena(ROM_ena), .ROM_addr(ROM_addr),
    .VDP_DI(DI), .VDP_A(A), .VDP_DTACK_N(DTACK_N),  
    .VDP_RNW(RNW), .VDP_SEL(SEL));
    
    vdp dut(.RST_N(RST_N), .CLK(CLK), .SEL(SEL), .RNW(RNW), .UDS_N(UDS_N), .LDS_N(LDS_N), 
                        .VRAM_DTACK_N(VRAM_DTACK_N), .INTERLACE(INTERLACE), .HINT_ACK(HINT_ACK),
                        .VINT_TG68_ACK(VINT_TG68_ACK), .VINT_T80_ACK(VINT_T80_ACK), 
                        .VBUS_DMA_ACK(VBUS_DMA_ACK),.VBUS_DTACK_N(VBUS_DTACK_N), .A(A),
                        .DI(DI), .VBUS_DATA(VBUS_DATA), .DO(DO), .DTACK_N(DTACK_N), .VRAM_DI(VRAM_DI),
                        .VRAM_DO(VRAM_DO),.VRAM_CE_N(VRAM_CE_N), .VRAM_UB_N(VRAM_UB_N), .VRAM_LB_N(VRAM_LB_N), 
                        .VRAM_OE_N(VRAM_OE_N), .VRAM_WE_N(VRAM_WE_N), .VRAM_SEL(VRAM_SEL), 
                        .HINT(HINT), .VINT_TG68(VINT_TG68), .VINT_T80(VINT_T80), .VBUS_DMA_REQ(VBUS_DMA_REQ), 
                        .VBUS_UDS_N(VBUS_UDS_N), .VBUS_LDS_N(VBUS_LDS_N), .VBUS_SEL(VBUS_SEL), 
                        .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), .VRAM_ADDR(VRAM_ADDR), .VBUS_ADDR(VBUS_ADDR),
                        .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B));
    
    //comment if synth
    /*initial begin
        CLK <=1'b1;
        forever #5 CLK <= ~CLK;
    end
    
    initial begin
        @(posedge CLK);
            RST_N <= 1'b0;  
        @(posedge CLK);
            RST_N <=1'b1;
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        #10000000;
        @(posedge CLK);
        INTERLACE <=1'b1;
        $finish;
     end*/
endmodule
