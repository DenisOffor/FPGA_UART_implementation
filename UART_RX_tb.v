module UART_RX_tb(output [7:0]Received_byte, output receive_state, output error);
	reg clk = 0;
	reg RX_data = 1;
		
	initial begin
		#400 RX_data <= 0;
		#400 RX_data <= 1; //10101010
		#400 RX_data <= 0;
		#400 RX_data <= 1;
		#400 RX_data <= 0;
		#400 RX_data <= 1;
		#400 RX_data <= 0;
		#400 RX_data <= 1;
		#400 RX_data <= 0;
		#400 RX_data <= 1;
		
		#1000 RX_data <= 0;
		#400 RX_data <= 1; //10101010
		#400 RX_data <= 0;
		#400 RX_data <= 1;
		#400 RX_data <= 0;
		#400 RX_data <= 0;
		#400 RX_data <= 0;
		#400 RX_data <= 0;
		#400 RX_data <= 1;
		#400 RX_data <= 0;
	end
	
	always
	  #10 clk = ~clk;
	  
	UART_RX UART_RX(.clk(clk), .RX_data(RX_data), .Received_byte(Received_byte), .receive_state(receive_state), .error(error));
endmodule