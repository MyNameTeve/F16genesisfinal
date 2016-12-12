onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+col_info_RAM -L xil_defaultlib -L xpm -L blk_mem_gen_v8_3_4 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.col_info_RAM xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {col_info_RAM.udo}

run -all

endsim

quit -force
