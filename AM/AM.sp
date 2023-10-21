*Project: AM Mixer Simulation
*Author: Rodrigo Rea
*Date: October 15th 2023
*Description: Simulation of an AM mixer using MC1496 IC.

.param r_load=51 r_feed=750 c_filter=0.1u
.include MC1496.lib

* === Voltage Sources ===
Vcc vcc 0 dc 12V
Vee 0 vee dc 8V
* Carrier and Message signal sources
Vcarrier carrier_in 0 dc 0 ac 1 SIN(0 25m 100k)
Vmessage signal_in 0 dc 0 ac 1 SIN(0 24m 10k)
 
* === Resistors ===
r1 signal_in 0 {r_load}
r2 carrier_aux 0 {r_load}
r3 mix_out filter_in {r_load}
r4 signal_in mix_in_pos {r_feed}
r5 carrier_aux mix_in_neg {r_feed}
r6 mix_out 0 1k
r7 mix_out vcc 1k
r8 mix_in_pos mix_in_neg 1k
r9 vcc carrier_out_pos 3.9k
r10 vcc carrier_out_neg 3.9k
r11 mix_aux 0 6.8k
r12 mix_in_pos mix_mid 26.5k
r13 mix_mid mix_in_neg 23.5k
r14 mix_mid vee 1

* === Capacitors ===
c1 mix_out 0 {c_filter}
c2 carrier_in filter_in {c_filter}

* === Instance of MC1496 Mixer ===
XU1 signal_in mix_in_pos mix_in_neg carrier_aux mix_aux carrier_out_pos mix_out filter_in carrier_out_neg vee MC1496

.control
op
tran 0.1u 300u
let vout = v(carrier_out_pos)
plot vout
wrdata t_output.raw vout 
hardcopy t_output.ps vout
tran 0.1u 1
let vout = v(carrier_out_pos)
linearize vout 
set specwindow=blackman
fft vout
plot db(vout) xlimit 0 1Meg
wrdata f_output.raw vout
hardcopy f_output.ps db(vout)
.endc

.end
