sim:
	iverilog -g2012 -o das.vvp rtl/*.v tb/das_tb.v && vvp das.vvp
clean:
	rm -f das.vvp das.vcd
