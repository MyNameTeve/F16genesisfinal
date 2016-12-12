-- Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2016.3 (win64) Build 1682563 Mon Oct 10 19:07:27 MDT 2016
-- Date        : Fri Dec 09 10:48:35 2016
-- Host        : DESKTOP-82NCE1H running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Workspace/F16genesisfinal/VDP/VSG.srcs/sources_1/ip/col_info_RAM/col_info_RAM_stub.vhdl
-- Design      : col_info_RAM
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity col_info_RAM is
  Port ( 
    clka : in STD_LOGIC;
    wea : in STD_LOGIC_VECTOR ( 0 to 0 );
    addra : in STD_LOGIC_VECTOR ( 8 downto 0 );
    dina : in STD_LOGIC_VECTOR ( 6 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 6 downto 0 )
  );

end col_info_RAM;

architecture stub of col_info_RAM is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,wea[0:0],addra[8:0],dina[6:0],douta[6:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_3_4,Vivado 2016.3";
begin
end;
