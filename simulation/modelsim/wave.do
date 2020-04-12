onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/CLK
add wave -noupdate /testbench/RESET
add wave -noupdate /testbench/AES_START
add wave -noupdate /testbench/AES_DONE
add wave -noupdate -radix hexadecimal /testbench/AES_KEY
add wave -noupdate -radix hexadecimal /testbench/AES_MSG_ENC
add wave -noupdate -radix hexadecimal /testbench/AES_MSG_DEC
add wave -noupdate /testbench/A/state
add wave -noupdate -radix hexadecimal /testbench/A/AddRoundKey_/chooseBits
add wave -noupdate -radix hexadecimal /testbench/A/outReg
add wave -noupdate -radix hexadecimal /testbench/A/invmcOut_
add wave -noupdate -radix hexadecimal /testbench/A/invSRout
add wave -noupdate -radix hexadecimal /testbench/A/invARK
add wave -noupdate -radix hexadecimal /testbench/A/invSBout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {192583 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 298
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {188442 ps} {229458 ps}
