// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.3 (win64) Build 1682563 Mon Oct 10 19:07:27 MDT 2016
// Date        : Fri Dec 09 10:48:35 2016
// Host        : DESKTOP-82NCE1H running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Workspace/F16genesisfinal/VDP/VSG.srcs/sources_1/ip/col_info_RAM/col_info_RAM_stub.v
// Design      : col_info_RAM
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_3_4,Vivado 2016.3" *)
module col_info_RAM(clka, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[8:0],dina[6:0],douta[6:0]" */;
  input clka;
  input [0:0]wea;
  input [8:0]addra;
  input [6:0]dina;
  output [6:0]douta;
endmodule
