library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FIFO_Transmitter is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           wr : in  STD_LOGIC;
           rd : in  STD_LOGIC;
           fifo_data_in : in  STD_LOGIC_VECTOR(7 downto 0);
           full : out  STD_LOGIC;
           empty : out  STD_LOGIC;
           fifo_data_out : out  STD_LOGIC_VECTOR(7 downto 0));
end FIFO_Transmitter;

architecture Behavioral of FIFO_Transmitter is
----------------Component
	COMPONENT Controller_Transmitter
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		rd : IN std_logic;
		wr : IN std_logic;          
		full : OUT std_logic;
		empty : OUT std_logic;
		w_addr : OUT std_logic_vector(1 downto 0);
		r_addr : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;
	
COMPONENT RAM_Transmitter
	PORT(
		clk : IN std_logic;
		we : IN std_logic;
		w_addr : IN std_logic_vector(1 downto 0);
		r_addr : IN std_logic_vector(1 downto 0);
		din : IN std_logic_vector(7 downto 0);          
		dout : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
----------------Signal
signal s_and : std_logic;
signal full_connection : std_logic;
signal r_addr_connection : std_logic_vector(1 downto 0);
signal w_addr_connection : std_logic_vector(1 downto 0);

begin
s_and <= wr and not full_connection;
full <= full_connection;
----------------Instatiation
Controlador_transmisor: Controller_Transmitter PORT MAP(
		clk => clk,
		reset => reset,
		rd => rd,
		wr => wr,
		full => full_connection,
		empty => empty,
		w_addr => w_addr_connection,
		r_addr => r_addr_connection
	);
Inst_RAM: RAM_Transmitter PORT MAP(
		clk => clk,
		we => s_and,
		w_addr => w_addr_connection,
		r_addr => r_addr_connection,
		din => fifo_data_in,
		dout => fifo_data_out 
	);
end Behavioral;
