// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.3 (win64) Build 1682563 Mon Oct 10 19:07:27 MDT 2016
// Date        : Fri Dec 09 10:45:58 2016
// Host        : DESKTOP-82NCE1H running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Workspace/F16genesisfinal/VDP/VSG.srcs/sources_1/ip/obj_info_RAM/obj_info_RAM_stub.v
// Design      : obj_info_RAM
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_3_4,Vivado 2016.3" *)
module obj_info_RAM(clka, wea, addra, dina, clkb, enb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[8:0],dina[15:0],clkb,enb,addrb[8:0],doutb[15:0]" */;
  input clka;
  input [0:0]wea;
  input [8:0]addra;
  input [15:0]dina;
  input clkb;
  input enb;
  input [8:0]addrb;
  output [15:0]doutb;
endmodule
