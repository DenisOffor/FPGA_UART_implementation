library verilog;
use verilog.vl_types.all;
entity UART_RX_tb is
    port(
        Received_byte   : out    vl_logic_vector(7 downto 0);
        receive_state   : out    vl_logic;
        error           : out    vl_logic
    );
end UART_RX_tb;
