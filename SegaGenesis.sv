module sega_genesis_top(
    input CLK100MHZ,
    input CPU_RESETN,
    output [3:0] VGA_R, VGA_G, VGA_B,
    output VGA_HS, VGA_VS
);
    logic [4:0] vdp_A;
    logic [15:0] vdp_di, vdp_do;
    logic vdp_clk, vdp_sel, vdp_rnw, vdp_uds_n, vdp_lds_n, vdp_dtack_n;
    
    logic [14:0] VRAM_ADDR;
    logic [15:0] VRAM_DO, VRAM_DI;
    logic VRAM_CE_N, VRAM_UB_N, VRAM_LB_N, VRAM_OE_N, VRAM_WE_N;
    logic VRAM_SEL, VRAM_DTACK_N;
    
    logic INTERLACE;
    
    logic vdp_hint, vdp_hint_ack;
    
    logic VINT_TG68, VINT_T80, VINT_TG68_ACK, VINT_T80_ACK;
    
    logic [23:0] VBUS_ADDR;
    logic [15:0] VBUS_DATA;
    logic VBUS_DMA_REQ, VBUS_DMA_ACK;
    logic VBUS_UDS_N, VBUS_LDS_N;
    logic VBUS_SEL, VBUS_DTACK_N;
    
    logic Z80_clk, M68_clk;
    logic [4:0] clk_divider_Z80, clk_divider_M68;
    
    assign vdp_clk = Z80_clk;
    
    logic HINT, HINT_ACK;
    logic [15:0]HV_count;
    logic [31:0]M68_addr;
    logic M68_as;
    logic [15:0]M68_data_in;
    logic [15:0]M68_data_out;
    logic M68_dtack;
    logic M68_lds;
    logic M68_rw;
    logic M68_uds;
    logic [4:0]VDP_A;
    logic [15:0]VDP_DI;
    logic [15:0]VDP_DO;
    logic VDP_DTACK_N;
    logic VDP_LDS_N;
    logic VDP_RNW;
    logic VDP_SEL;
    logic VDP_UDS_N;
    logic [15:0]VDP_VBUS_DATA;
    logic VDP_VBUS_DTACK_N;
    logic VDP_VBUS_SEL;
    logic VINT_T80;
    logic VINT_TG68;
    logic VINT_TG68_ACK;
    logic [15:0]Z80_addr;
    logic [7:0]Z80_data;
    logic Z80_mreq;
    logic Z80_rd;
    logic Z80_wr;
    logic Z80_rfsh;
    logic Z80_halt;
    
    logic ROM_as;
    logic DMA_as;
       
    assign ROM_as = (M68_addr <= 24'h400000) ? 0 : 1;
    assign DMA_as = (M68_addr >= 24'hFF0000) ? 0 : 1;  
        
    ROM_Handler_Top_wrapper rom(.addr(M68_addr),.as(ROM_as),.clk(M68_CLK),.data(M68_data_in),.dtack(M68_dtack));
       
    z80_top_direct_n z80(.nM1(), .nMREQ(Z80_mreq), .nIORQ(), .nRD(Z80_rd), .nWR(Z80_wr), .nRFSH(Z80_rfsh),
                         .nHALT(Z80_halt), .nBUSACK(Z80_busack), .nWAIT(), .nNMI(1'b1), .nRESET(CPU_RESETN),.nBUSRQ(),
                         .CLK(Z80_clk), .A(Z80_addr), .D(Z80_data));
                         
    DMA_top_wrapper dma(.HINT(),.HINT_ACK(),.HV_count(),.M68_addr(),.M68_as(DMA_as),
            .M68_data_in(),.M68_data_out(),.M68_dtack(),.M68_lds(),.M68_rw(),
                             .M68_uds(),.VDP_A(),.VDP_DI(),.VDP_DO(),.VDP_DTACK_N(),
                             .VDP_LDS_N(),.VDP_RNW(),.VDP_SEL(),.VDP_UDS_N(),.VDP_VBUS_DATA(),
                             .VDP_VBUS_DTACK_N(),.VDP_VBUS_SEL(),
                             .VINT_T80(),.VINT_TG68(),.VINT_TG68_ACK(),.Z80_addr(),
                             .Z80_data(),.Z80_mreq(),.Z80_rd(),.Z80_wr(),
                             .clk(M68_CLK),.rst_n(CPU_RESETN));
                             
    TG68 M68(.clk(M68_CLK), .reset(CPU_RESETN), .clkena_in(1'b1), .data_in(M68_data_in), 
             .IPL(), .dtack(M68_dtack), .addr(M68_addr), .data_out(M68_data_out), 
             .as(M68_as), .uds(M68_uds), .lds(M68_lds), .rw(M68_rw), .enaRDreg(), .enaWReg(),
             .intack());
    
    VRAM vram (.addra({VRAM_ADDR, 1'b0}), .clka(vdp_clk), .dina(VRAM_DI[15:8]), .douta(VRAM_DO[15:8]), .ena(~VRAM_UB_N && ~VRAM_CE_N), .wea(~VRAM_WE_N),
                       .addrb({VRAM_ADDR, 1'b1}), .clkb(vdp_clk), .dinb(VRAM_DI[7:0]), .doutb(VRAM_DO[7:0]), .enb(~VRAM_LB_N && ~VRAM_CE_N), .web(~VRAM_WE_N));
    
    vdp video(.CLK(vdp_clk), .RST_N(CPU_RESETN), .SEL(vdp_sel), .A(vdp_A), .RNW(vdp_rnw), .UDS_N(vdp_uds_n),
              .LDS_N(vdp_lds_n), .DI(vdp_di), .DO(vdp_do), // Might need to rename this since "do" is a sv keyword
              .DTACK_N(vdp_dtack_n), .VRAM_ADDR, .VRAM_CE_N, .VRAM_UB_N, .VRAM_LB_N, .VRAM_DO, .VRAM_DI,
              .VRAM_OE_N, .VRAM_WE_N, .VRAM_SEL, .VRAM_DTACK_N, .INTERLACE, .HINT(vdp_hint), .HINT_ACK(vdp_hint_ack),
              .VINT_TG68, .VINT_T80, .VINT_TG68_ACK, .VINT_T80_ACK, .VBUS_DMA_REQ, .VBUS_DMA_ACK, .VBUS_ADDR,
              .VBUS_UDS_N, .VBUS_LDS_N, .VBUS_DATA, .VBUS_SEL, .VBUS_DTACK_N, .VGA_R, .VGA_G, .VGA_B, .VGA_HS,
              .VGA_VS);
    
    enum logic [1:0] {
        IDLE, VRAM_OPERATING
    } state, nextState;
    
    always_ff @(posedge CLK100MHZ, negedge CPU_RESETN) begin
        if (~CPU_RESETN) begin
            clk_divider_Z80 <= 0;
            Z80_clk <= 0;
            clk_divider_M68 <= 0;
            M68_clk <= 0;
        end
        else begin
            if (clk_divider_Z80 == 27) begin //3.57 MHz
                clk_divider_Z80 <= 0;
                Z80_clk <= ~Z80_clk;
            end
            else begin
                clk_divider_Z80 <= clk_divider_Z80 + 1;
            end
            if (clk_divider_M68 == 13) begin //7.67 MHz
                clk_divider_M68 <= 0;
                M68_clk <= ~M68_clk;
            end
            else begin
                clk_divider_M68 <= clk_divider_M68 + 1;
            end
        end
    end
    
    always_comb begin // Next state logic
        case (state)
            IDLE: begin
                if (~VRAM_CE_N) begin //Read enable
                    nextState = VRAM_OPERATING;
                end
            end
            
            VRAM_OPERATING: begin
                nextState = IDLE;
            end
        endcase
    end
    
    always_comb begin // Output logic
        case (state)
            IDLE: begin
                VRAM_DTACK_N = 1;
            end
            VRAM_OPERATING: begin
                VRAM_DTACK_N = 0;
            end
        endcase
    end
    
endmodule