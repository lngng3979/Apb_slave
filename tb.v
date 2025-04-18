module apb_slave_tb;

  // Testbench signals
  reg pclk;
  reg rst;
  reg psel;
  reg penable;
  reg pwrite;
  reg [7:0] paddr;
  reg [15:0] pwdata;
  wire [15:0] prdata;
  wire pready;

  // Instantiate the apb_slave module
  apb_slave uut (
    .pclk(pclk),
    .rst(rst),
    .psel(psel),
    .penable(penable),
    .pwrite(pwrite),
    .paddr(paddr),
    .pwdata(pwdata),
    .prdata(prdata),
    .pready(pready)
  );

  // Clock generation
  always begin
    #5 pclk = ~pclk;  // 100MHz clock
  end

  // Test sequence
  initial begin
    // Initialize signals
    pclk = 0;
    rst = 0;
    psel = 0;
    penable = 0;
    pwrite = 0;
    paddr = 8'b0;
    pwdata = 16'b0;

    // Set up waveform dump
    $dumpfile("apb_slave_tb.vcd");   // VCD file to store the waveform
    $dumpvars(0, apb_slave_tb);       // Dump all signals from the testbench module

    // Apply reset
    rst = 1;
    #10 rst = 0; // Release reset

    // Test Case 1: Write to memory
    psel = 1; pwrite = 1; paddr = 8'h10; pwdata = 16'hA5A5;
    #10 penable = 1;  // Start write operation
    #10 penable = 0;  // End write operation
    psel = 0;

    // Test Case 2: Read from memory
    psel = 1; pwrite = 0; paddr = 8'h10; pwdata = 16'b0;
    #10 penable = 1;  // Start read operation
    #10 penable = 0;  // End read operation
    psel = 0;

    // Test Case 3: Idle state
    #20 psel = 0; penable = 0; pwrite = 0;

    // End simulation
    #50 $finish;
  end

  // Monitor the outputs
  initial begin
    $monitor("Time: %0t | pclk: %b | rst: %b | psel: %b | penable: %b | pwrite: %b | paddr: %h | pwdata: %h | prdata: %h | pready: %b", 
             $time, pclk, rst, psel, penable, pwrite, paddr, pwdata, prdata, pready);
  end

endmodule

