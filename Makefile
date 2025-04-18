apbslave_tb :apbslave.v apbslave_tb.v
	iverilog apbslave.v apbslave_tb.v
apbslave.vcd:a.out
	./a.out
debug : apbslave.vcd
	gtkwave apbslave.vcd
all : apbslave_tb apbslave.vcd debug 
clean: 
	rm -rf a.out apbslave.vcd 

