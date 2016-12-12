onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib obj_info_RAM_opt

do {wave.do}

view wave
view structure
view signals

do {obj_info_RAM.udo}

run -all

quit -force
