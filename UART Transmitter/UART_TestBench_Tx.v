module tx_tb;

    reg clk;
    wire data_out_tx;
    reg [7:0] data_in;
    reg tx_ready_in;
    wire tx_ongoing, tx_done;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 10 ns (50 MHz)
    end

    // Instantiate the UART_Transmitter module
    UART_Transmitter tx(.clk(clk),.data_in(data_in),.tx_ready_in(tx_ready_in),.tx_ongoing(tx_ongoing),.tx_done(tx_done),.data_out_tx(data_out_tx));

    initial begin
        $dumpfile("tx.vcd"); 
        $dumpvars(0, tx_tb);

        // Apply stimulus to serial_input
        #2 data_in = 8'b10110111; tx_ready_in = 1'b1;
        #10 tx_ready_in = 1'b0;
        
        #6000
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time: %0t | Clock: %b | Data In: %b | TX Ready In: %b | TX Ongoing: %b | TX Done: %b | Data Out TX: %b", 
                 $time, clk, data_in, tx_ready_in, tx_ongoing, tx_done, data_out_tx);
    end
endmodule
