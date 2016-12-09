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
  input logic CLK100MHZ, CPU_RESETN, 
  output logic [3:0] VGA_R, VGA_B, VGA_G,
  output logic VGA_HS, VGA_VS,
  input logic [1:0] SW,
  output logic AUD_PWM, AUD_SD);
  
  logic RST_N, CLK;
  assign RST_N = CPU_RESETN;
  
  clk_wiz_0 vdpclk(.clk_in1(CLK100MHZ), .clk_out1(CLK));
  //comment if synth
  
  //logic [3:0] VGA_R, VGA_G, VGA_B;
  
    (* mark_debug = "true" *)
    logic HINT, VINT_TG68, VINT_T80;
    
    logic SEL, RNW, UDS_N, LDS_N, VRAM_DTACK_N, INTERLACE, HINT_ACK,
                    VINT_TG68_ACK, VINT_T80_ACK, VBUS_DMA_ACK,VBUS_DTACK_N;
    logic [4:0] A;
    logic [15:0] DI, VBUS_DATA, DO, VRAM_DI, VRAM_DO;
    logic DTACK_N, VRAM_CE_N, VRAM_UB_N, VRAM_LB_N, VRAM_OE_N, VRAM_WE_N, VRAM_SEL, 
                    VBUS_DMA_REQ, VBUS_UDS_N, VBUS_LDS_N,
                    VBUS_SEL;   
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
 
    assign AUD_SD = 1'b1;
                            
    logic nWE, nCE;
    logic CLK_TI;
    logic [7:0] D;
    logic READY;
    
    logic [4:0] divider;
    logic [15:0] music_unit;
    logic [24:0] music_ctr;
    logic latch;
    logic tone_latch;
    
    ti_top ti(.nWE(nWE), .nCE(nCE), .CLK(CLK_TI), .nRST(CPU_RESETN), .D(D), .READY(READY), .AOUT(AUD_PWM));
    
    (* mark_debug = "true" *)
    enum logic [2:0] {
        START, IDLE, SET_TONE_1, WAIT_1_PWM, WAIT_2_PWM, SET_VOLUME_1,
        SET_TONE_2, SET_VOLUME_2
    } state, nextState;
    
    always_ff @(posedge CLK100MHZ, negedge CPU_RESETN) begin
            if(!CPU_RESETN) begin
                CLK_TI <= 0;
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
                    CLK_TI <= ~CLK_TI;
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
 /*   
     initial begin
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
