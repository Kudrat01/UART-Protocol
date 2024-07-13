# UART_Protocol
Implemented the UART protocol in Verilog, designing reliable transmitter and receiver modules. Verified data transmission and reception in Test Bench using Icarus Verilog and GTKWave, gaining valuable experience in serial communication protocols and Verilog design.

# **General Description of UART**
Universal Asynchronous Receiver/Transmitter (UART) is a hardware communication protocol that facilitates serial communication between devices by converting parallel data from a microcontroller into a serial form and vice versa. It operates asynchronously, meaning it does not require a clock signal to synchronize the transmitter and receiver. Instead, it uses start, stop, and parity bits to ensure data integrity. UART is widely used in embedded systems, computers, and communication devices due to its simplicity and reliability in transmitting data over a serial line, making it ideal for low-speed, short-distance communication.

# **UART Receiver**
The UART Receiver module is designed to interpret serial data input and convert it into an 8-bit parallel output. It operates using a finite state machine (FSM) with defined states for idling, detecting the start bit, reading data bits, verifying the stop bit, and cleaning up the state for the next operation. The receiver samples the serial input based on a specified clock frequency and baud rate, ensuring accurate data reception. The module's test bench simulates the receiver's operation, generating a clock signal and providing a sequence of serial inputs to validate its functionality. The test bench also monitors and logs the relevant signals, confirming that the receiver correctly outputs the received data.

# **UART Transmitter Description**
The UART Transmitter module converts 8-bit parallel data into a serial form for transmission over a communication line. Similar to the receiver, it uses a finite state machine (FSM) to manage its states, including idling, sending the start bit, transmitting data bits, sending the stop bit, and performing data cleanup. The transmitter ensures that the data is sent at the correct baud rate by counting clock cycles. The provided test bench for the transmitter generates the necessary clock signal and applies input data to test the transmission process. It logs the transmission status and output signals to verify that the transmitter accurately sends the serial data as intended.

# **Achieving Results in UART Receiver**
In the UART Receiver module, the result is achieved through a series of well-defined states in a finite state machine (FSM) that processes the incoming serial data bit by bit. Here's a breakdown of how the receiver works:

State Initialization: The FSM starts in the state_idle state, waiting for the start bit. All control elements, such as opready, clock_count, and bit_index, are reset.
Start Bit Detection: When the receiver detects a low signal (0), it transitions to the state_start_bit state to confirm the presence of the start bit. It ensures the start bit is valid by waiting for half the bit duration (clock_per_bit/2).
Data Bit Reception: Once the start bit is confirmed, the FSM moves to the state_data_bit state. Here, it reads each incoming data bit. The clock_count is used to synchronize with the incoming data rate, sampling each bit at the middle of its duration to avoid errors due to signal transitions.
Stop Bit Verification: After receiving all 8 data bits, the FSM transitions to the state_stop_bit state to check the stop bit. The clock_count ensures the receiver waits the correct amount of time before reading the stop bit.
Data Cleanup: Once the stop bit is verified, the FSM moves to the state_data_cleanup state, setting the opready signal to indicate that the data is ready to be read. It then transitions back to state_idle to prepare for the next byte of data.
The test bench validates this process by providing a sequence of serial inputs that simulate a typical UART transmission. It monitors the signals and ensures the receiver correctly interprets and outputs the 8-bit data.

# **Achieving Results in UART Transmitter**
In the UART Transmitter module, the result is achieved by converting parallel data into serial data through a finite state machine (FSM) that sequentially sends each bit. Here's a breakdown of how the transmitter works:

State Initialization: The FSM starts in the state_idle state, waiting for a signal to start transmission (tx_ready_in). All control elements, such as data_out_tx, clock_count, and bit_index, are reset.
Start Bit Transmission: When tx_ready_in is asserted, the FSM transitions to the state_start_bit state. It sets data_out_tx to 0 to send the start bit and waits for the duration of one bit (clock_per_bit).
Data Bit Transmission: After sending the start bit, the FSM moves to the state_data_bit state. Here, it transmits each bit of the data_in input sequentially. The clock_count is used to ensure each bit is sent for the correct duration.
Stop Bit Transmission: Once all 8 data bits are transmitted, the FSM transitions to the state_stop_bit state. It sets data_out_tx to 1 to send the stop bit and waits for the duration of one bit.
Data Cleanup: After sending the stop bit, the FSM moves to the state_data_cleanup state, setting tx_done to indicate the completion of the transmission. It then transitions back to state_idle to prepare for the next data to be transmitted.
The test bench validates this process by providing a data input and controlling the tx_ready_in signal to start the transmission. It monitors the signals and ensures the transmitter correctly sends the serial data, matching the expected UART protocol.
