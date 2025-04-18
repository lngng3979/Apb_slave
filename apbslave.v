module apbslave(
	input pclk ,
	input rst,
	input psel,
	input penable,
	input [7:0] paddr,
	input [15:0] pwdata,
	input pwrite,
	output pready ,
	output reg [15:0] prdata

);
	parameter IDLE = 3'b001;
	parameter SETUP= 3'b010;
	parameter ACCESS= 3'b100;
	reg [2:0] cur_st,nx_st;
	reg dev_sel;
	reg [15:0] mem [0:255];

	assign pready = 1'b1;
	always @(*) begin
		dev_sel=0;
		case (cur_st) 
			IDLE :   
				if(psel) 
					nx_st=SETUP;
				
				else 
					nx_st    =cur_st;
				
			SETUP:
				if(penable)
					nx_st = ACCESS;
				else 	
					nx_st = cur_st;

			ACCESS: begin 
				dev_sel = 1;

				if(psel) 
					nx_st= SETUP;
				else    
					nx_st = IDLE;
				end
			default: ;
		endcase
	end
	
	always @(posedge pclk or posedge rst) begin
			if(rst) 
				cur_st <= IDLE ;
			else 	
			
			begin
				cur_st <= nx_st;

				if(dev_sel)
				
				begin
					if (pwrite)
				
					mem[paddr] <= pwdata;
				
					else 
					prdata <= mem[paddr];
				
				end
		 	end
	end

endmodule

