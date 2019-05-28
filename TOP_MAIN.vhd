library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP_MAIN is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           rx : in  STD_LOGIC;
           dout : out  STD_LOGIC_VECTOR (7 downto 0);
           rx_done_tick : out  STD_LOGIC);
end TOP_MAIN;

architecture Behavioral of TOP_MAIN is
--COMPONENT
COMPONENT bRATE_generator
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;          
		tick : OUT std_logic
		);
	END COMPONENT;


COMPONENT UART_receiver
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		rx : IN std_logic;
		s_tick : IN std_logic;          
		rx_done : OUT std_logic;
		dout : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
--SIGNAL
signal s1: std_logic;
begin
--INSTANTIATIONS

Inst_bRATE_generator: bRATE_generator PORT MAP(
		clk => clk ,
		reset => reset,
		tick => s1
	);
	
Inst_UART_receiver: UART_receiver PORT MAP(
		clk =>clk ,
		reset => reset,
		rx => rx,
		s_tick =>s1 ,
		rx_done => rx_done_tick,
		dout => dout
	);

end Behavioral;

