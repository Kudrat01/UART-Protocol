module UART_Reciever(input clk, input serial_input, output opready,  output [7:0] data_out_rx);

    parameter clock_per_bit = 50;              //**ASSUMED 50**, can be calculated as (frequency of clock)/(baud rate of UART) 
                                               //             and parameter value can be specified by overiding the parameter value
    parameter state_idle = 3'b000;
    parameter state_start_bit = 3'b001;
    parameter state_data_bit = 3'b010;
    parameter state_stop_bit = 3'b011;
    parameter state_data_cleanup = 3'b100;
    

    reg [2:0] state;
    reg read_data;
    reg [7:0] clock_count;
    reg opready;
    reg [7:0] data_out_rx;
    reg [3:0] bit_index;


    always @(posedge clk)
        begin
            read_data <= serial_input;        
            // read_data <= serial_input;            //For actual hardware implementation it was suggested to use double register to avoid metastability
            // read_data_stable <= read_data;        //(one for storing the new variablea and other for older variable)
        end


    always @(posedge clk)
    begin
        case(state)

            state_idle:
                begin
                    opready <= 0;               // Basically reset every control elements
                    clock_count <= 0;
                    bit_index <= 0;
                    if(read_data == 1'b0)        //start bit , first time value dop from 1 to 0
                        state = state_data_bit;
                    else
                        state = state_idle;        
                end


            state_start_bit:
                begin
                    if(clock_count == clock_per_bit/2)
                        begin
                            if(read_data == 1'b0)
                                clock_count <= 0;
                                state <= state_data_bit;
                            else
                                state <= state_idle;
                        end
                    else
                        begin
                            clock_count <= clock_count + 1;
                            state <= state_start_bit;
                        end
                end


            state_data_bit:
                begin
                    if(clock_count > clock_per_bit-1)          // Since my clock per cycle large(generally is large for UART), i will wait until clock_per_bit-1 to sample a stablized output 
                        begin
                            clock_count <= 0;
                            if(bit_index >7 )
                                begin
                                    bit_index <= 0;
                                    state <= state_stop_bit;
                                end
                            else
                                begin
                                    data_out_rx[bit_index] <= read_data;
                                    bit_index <= bit_index + 1; 
                                    state <= state_data_bit;
                                end
                        end
                    else
                        begin
                            clock_count <= clock_count+1;
                            state <= state_data_bit;
                        end
                end


            state_stop_bit:
                begin
                    if(clock_count > clock_per_bit-1)       //wait clock-per_bit-1, and then apply stop bit for proper timing of stop bit, to stikc to baud rate
                        begin
                            opready <= 1'b1;                    // ready to stop, ready to go to dataclean up and ready for data reading.
                            clock_count <= 0;
                            state <= state_data_cleanup;
                        end
                    else
                        begin
                            clock_count <= clock_count+1;
                            state <= state_stop_bit;
                        end
                end


            state_data_cleanup:
                begin
                    state <= state_idle;
                    opready <= 1'b0;
                end


            default:
                state <= state_idle;

        endcase
    end
endmodule
