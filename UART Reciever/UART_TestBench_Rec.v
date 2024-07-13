module rec_tb;

    reg clk;
    wire opready;
    wire [7:0] data_out_rx;
    reg serial_input = 1'b1;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 10 ns (50 MHz)
    end

    // Instantiate the UART_Receiver module
    UART_Reciever rec(.clk(clk),.serial_input(serial_input),.opready(opready),.data_out_rx(data_out_rx));

    initial begin
        $dumpfile("rec.vcd"); 
        $dumpvars(0, rec_tb);

        // Apply stimulus to serial_input
        #2 serial_input = 1'b1;             // initial =1
        #500 serial_input = 1'b0;           // start bit =0
        #500 serial_input = 1'b1;           // 0 bit
        #500 serial_input = 1'b0;           // 1 bit
        #500 serial_input = 1'b1;           // 2 bit
        #500 serial_input = 1'b1;           // 3 bit
        #500 serial_input = 1'b0;           // 4 bit
        #500 serial_input = 1'b0;           // 5 bit
        #500 serial_input = 1'b1;           // 6 bit
        #500 serial_input = 1'b1;           // 7 bit
        #500 serial_input = 1'b1;           // stop bit = 1
        #2000 
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time: %0t | Clock: %b | Serial Input: %b | opready: %b | data_out_rx: %b", 
                 $time, clk, serial_input, opready, data_out_rx);
    end
endmodule
