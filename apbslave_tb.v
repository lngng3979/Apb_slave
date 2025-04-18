`timescale 1ns/10ps
`define PERIOD 10  

module apbslave_tb;
 	reg pclk ;
	reg rst;
	reg psel;
	reg penable;
	reg [7:0] paddr;
	reg [15:0] pwdata;
	reg pwrite;	
	wire pready;
	wire [15:0] prdata;
	
	apbslave DUT (pclk ,rst, psel , penable, paddr , pwdata, pwrite, pready,prdata );
	
	integer i,j;
	initial begin
	pclk =0 ;
	forever #((`PERIOD)/2) pclk = ~pclk ; 
	end

	task write_data ();
	
	begin		
	i=0;
	//write transaction
        repeat(256)
	begin

	psel =1 ;
        //#(`PERIOD ); //setup state
        
	waitforclk(1);
	penable =1 ;
        pwrite =1 ;
        paddr = i;
        pwdata = i;
        //#(`PERIOD ); //access
	waitforclk(1);
        while (!pready )
        	#(`PERIOD ); //wait 1 clk
	$display("wdata: %d ",DUT.mem[i]);
	i = i +1;
	end
	end

	endtask
	
	task read_data();
        begin
	j=0;
	repeat (256)
	begin	
	psel =1 ;
	#(`PERIOD ); //setup state 
	penable =1 ;
	pwrite =0 ;
	paddr = j;
	//pwdata = 16'haa55;
	#(`PERIOD ); //access
	while (!pready ) 
	  	#(`PERIOD ); //wait 1 clk 
	$display("rdata: %d ",DUT.mem[j]);
	j = j+1;
	end
	end
	endtask

	task waitforclk (input integer n) ; 
		repeat(n) 
			@(posedge pclk) ;	
	endtask
	
	initial begin
	$dumpfile("apbslave.vcd");
	$dumpvars(0,apbslave_tb);
	
	rst = 1;
	psel =0 ;
	penable =0 ;
	paddr = 0 ;
	pwdata =0;
	pwrite =0 ;
	#0.1
	#(`PERIOD *2);


	rst =0 ;
	psel =1;
/*
	waitforclk(1);
	write_data();
	psel=1;
	waitforclk(1);
	read_data();
	waitforclk(5);
*/
		//write_data();
	psel =1 ;
        #(`PERIOD ); //setup state
        penable=1 ;
        pwrite = 1 ;
        paddr  = 8'b00000000;
        pwdata = 16'haa55;
        #(`PERIOD); //access
        while (!pready )
                #(`PERIOD ); //wait 1 clk
	waitforclk(1);

	psel =1 ;
        #(`PERIOD ); //setup state
        penable = 1 ;
        pwrite  = 0 ;
        paddr   = 8'b00000000;
        //pwdata = 16'haa55;
        #(`PERIOD ); //access
        while (!pready )
                #(`PERIOD ); //wait 1 clk
	//read_data();
	waitforclk(10);
	
	/*
	//write transaction 
	psel =1 ;
	#(`PERIOD ); //setup state 
	penable =1 ;
	pwrite =1 ;
	paddr = 8'b00001011;
	pwdata = 16'haa55;
	#(`PERIOD ); //access
	while (!pready ) 
	  	#(`PERIOD ); //wait 1 clk 

	*/	
	//psel =0 ;
	//penable =0 ; 
	//pwrite  =0 ;
		
/*	
	//read transaction 
	//#(`PERIOD*3);
	psel =1 ;
	#(`PERIOD ); //setup state 
	penable =1 ;
	pwrite =0 ;
	//paddr = 8'b00001011;
	//pwdata = 16'haa55;
	#(`PERIOD ); //access
	while (!pready ) 
	  	#(`PERIOD ); //wait 1 clk 

	//write transaction 
	psel =1 ;
	#(`PERIOD ); //setup state 
	penable =1 ;
	pwrite =1 ;
	paddr = 8'b00001100;
	pwdata = 16'haa56;
	#(`PERIOD ); //access
	while (!pready ) 
	  	#(`PERIOD ); //wait 1 clk 
	
	//read transaction 
	psel =1 ;
	#(`PERIOD ); //setup state 
	penable =1 ;
	pwrite =0 ;
	paddr = 8'b00001100;
	//pwdata = 16'haa55;
	#(`PERIOD ); //access
	while (!pready ) 
	  	#(`PERIOD ); //wait 1 clk 
	
		
		#(`PERIOD);//wait for one clk
	*/
	$finish ();

	end

	endmodule
