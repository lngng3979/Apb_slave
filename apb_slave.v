module apb_slave (
      	//input signal 
	input pclk ,
	input rst , 
	input psel ,
	input penable,
	input pwrite ,
	input [7:0] paddr,
	input [15:0] pwdata,
	//output signal
	output reg [15:0] prdata,
	output pready
);
	parameter IDLE = 3'b001;
	parameter SETUP = 3'b010;
	parameter ACCESS = 3'b100;

	reg [2:0] cst, nxt;
	assign pready = 1;

	logic [15:0] mem [0:255] ;
	reg acc_ena;

	always @(posedge pclk or posedge rst) begin
		if ( rst) 
			cst <= IDLE;
		else 
			cst <= nxt ;
	end

	always @(posedge pclk) begin 
		if (acc_ena) begin 
			if (pwrite)
					mem[paddr] <= pwdata;
				else 
					prdata 	   <= mem[paddr];
			end
		end

	always @* begin 
		acc_ena =0 ;
		case (cst) 
			IDLE: 
				if (psel) 
					nxt = SETUP;
				else 
					nxt = cst;
			SETUP:
				if(penable) 
				begin
					nxt = ACCESS;
				end

				else    nxt = cst;


			ACCESS: begin
					acc_ena = 1;
				
					if (psel) 
						nxt = SETUP;
					else
						nxt = IDLE;
				end
			default: ;	
			endcase
		end

endmodule
