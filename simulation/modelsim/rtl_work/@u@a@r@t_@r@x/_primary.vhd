library verilog;
use verilog.vl_types.all;
entity UART_RX is
    generic(
        CLOCK_PER_BIT   : integer := 20
    );
    port(
        clk             : in     vl_logic;
        RX_data         : in     vl_logic;
        Received_byte   : out    vl_logic_vector(7 downto 0);
        receive_state   : out    vl_logic;
        error           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CLOCK_PER_BIT : constant is 1;
end UART_RX;
