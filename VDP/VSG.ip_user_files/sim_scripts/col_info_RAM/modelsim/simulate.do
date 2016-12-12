onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L xpm -L blk_mem_gen_v8_3_4 -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.col_info_RAM xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {col_info_RAM.udo}

run -all

quit -force
