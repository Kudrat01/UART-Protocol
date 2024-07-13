module UART_Transmitter(input clk, input [7:0] data_in, input tx_ready_in, output tx_ongoing, output tx_done, output data_out_tx);

     parameter clock_per_bit = 50;              //**ASSUMED 50**, can be calculated as (frequency of clock)/(baud rate of UART) 
                                               //             and parameter value can be specified by overiding the parameter value
    parameter state_idle = 3'b000;
    parameter state_start_bit = 3'b001;
    parameter state_data_bit = 3'b010;
    parameter state_stop_bit = 3'b011;
    parameter state_data_cleanup = 3'b100;


    reg [2:0] state = 3'b000;
    reg data_out_tx = 1'b0;
    reg [7:0] clock_count;
    reg [7:0] data_in_copy;
    reg [3:0] bit_index = 4'b0000;
    reg tx_ready_in_copy;
    reg tx_done,tx_ongoing;

    always @(posedge clk)
    begin
        data_in_copy <= data_in;
        tx_ready_in_copy <= tx_ready_in;
    end

    always @(posedge clk)
    begin
        case(state)

            state_idle:
                begin
                    data_out_tx <= 1'b1;
                    tx_done <= 1'b0;
                    tx_ongoing <= 1'b0;
                    clock_count <= 0;
                    bit_index <= 0;
                    if(tx_ready_in == 1'b1)
                    begin
                        tx_ongoing<= 1'b1;
                        state <= state_start_bit;
                    end
                    else
                        state <= state_idle;
                end

            state_start_bit:
                begin  
                    data_out_tx <= 1'b0;
                    if(clock_count < clock_per_bit-1)
                    begin
                        clock_count <= clock_count + 1;
                        state <= state_start_bit;
                    end
                    else
                    begin
                        state <= state_data_bit;
                        clock_count <= 0;
                    end
                end
                
            state_data_bit:
                begin
                    data_out_tx <= data_in_copy[bit_index];
                    if(clock_count < clock_per_bit-1 & bit_index <= 7)
                        begin
                            clock_count <= clock_count + 1;
                            state <= state_data_bit;
                        end
                    else
                        begin
                            clock_count <= 0;
                            if(bit_index > 7)
                                begin
                                    bit_index <= 0;
                                    state <= state_stop_bit;
                                end
                            else
                                begin
                                    
                                    bit_index <= bit_index + 1;
                                    state <= state_data_bit;
                                end
                        end
                end    

            state_stop_bit:
                begin
                    if(clock_count < clock_per_bit-1)
                        begin
                            data_out_tx = 1'b1;
                            clock_count <= clock_count + 1;
                            state <= state_stop_bit;
                        end
                    else
                        begin
                            tx_done <= 1'b1;
                            tx_ongoing <= 1'b0;
                            state <= state_data_cleanup;
                            clock_count <= 0;
                        end
                end

            state_data_cleanup:
                begin
                    tx_done <= 1'b0;
                    state <= state_idle;
                end

            default:
                state <= state_idle;
        endcase
    end
endmodule