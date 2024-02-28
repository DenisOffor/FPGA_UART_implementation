module UART_RX #(parameter CLOCK_PER_BIT = 20)(input clk, input RX_data, output [7:0]Received_byte, output receive_state, output error);
	reg RX_data_switch[1:0];
	reg [7:0]rx_counter;
	reg [2:0]receive_task;
	
	reg [7:0]RX_byte;
	reg [2:0]bits_num;
	reg RX_state;
	reg error_state;
	
	parameter IDLE_STATE = 3'b000;
	parameter CHECK_START_BIT = 3'b001;
	parameter RECEIVE_BYTE = 3'b010;
	parameter CHECK_STOP_BIT = 3'b011;
	parameter CLEAR_STATE = 3'b100;
	
	initial begin
		RX_byte <= 0;
		error_state <= 0;
		RX_state <= 0;
	end
	
	always @(posedge clk)
	begin
		RX_data_switch[0] <= RX_data;
		RX_data_switch[1] <= RX_data_switch[0];
	end
	
	always @(posedge clk)
	begin
		case(receive_task)
		IDLE_STATE:
		begin
			rx_counter <= 0;
			bits_num <= 0;
			RX_state <= 0;
			error_state <= 0;
			
			if(RX_data_switch[1] == 1'b0)
				receive_task <= CHECK_START_BIT;
			else
				receive_task <= IDLE_STATE;
		end
		
		CHECK_START_BIT:
		begin
			if(rx_counter > ((CLOCK_PER_BIT - 1)/2))
			begin
				if(RX_data_switch[1] == 1'b0)
				begin
					receive_task <= RECEIVE_BYTE;
					rx_counter <= 0;
				end
				else
					receive_task <= IDLE_STATE;
			end
			else
			begin
				rx_counter <= rx_counter + 1;
				receive_task <= CHECK_START_BIT;
			end
		end
		
		RECEIVE_BYTE:
		begin
			if(rx_counter > (CLOCK_PER_BIT - 1))
			begin
				RX_byte[bits_num] <= RX_data_switch[1];
				rx_counter <= 0;
				if(bits_num < 7)
				begin
					bits_num <= bits_num + 1;
					receive_task <= RECEIVE_BYTE;
				end
				else
				begin
					bits_num <= 0;
					receive_task <= CHECK_STOP_BIT;
				end
			end
			else
			begin
				rx_counter <= rx_counter + 1;
				receive_task <= RECEIVE_BYTE;
			end
		end
		
		CHECK_STOP_BIT:
		begin 
			if(rx_counter > (CLOCK_PER_BIT - 1))
			begin
				if(RX_data_switch[1] == 1'b0)
				begin
					receive_task <= CLEAR_STATE;
					error_state <= 1'b1;
					rx_counter <= 0;
				end
				else
				begin
					receive_task <= CLEAR_STATE;
					RX_state <= 1'b1;
					rx_counter <= 0;
				end
			end
			else
			begin
				rx_counter <= rx_counter + 1;
				receive_task <= CHECK_STOP_BIT;
			end
		end
		
		CLEAR_STATE:
		begin
			receive_task <= IDLE_STATE;
			RX_state <= 1'b0;
			error_state <= 1'b0;
		end
		
		default: receive_task <= IDLE_STATE;
		endcase
	end
	
	assign receive_state = RX_state;
	assign Received_byte = RX_byte;
	assign error = error_state;
endmodule