library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP_UART is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           rx : in  STD_LOGIC; --dato recibido por receptor
			  tx : out STD_LOGIC; --dato transmitido por transmisor
			  ready : out STD_LOGIC;
			  tx_full : OUT std_logic;          
			  wr : IN std_logic;
			  w_data : IN std_logic_vector(7 downto 0);
			  tiempo_p : out std_logic_vector(7 downto 0);
			  tiempo_a : out std_logic_vector(7 downto 0));
           --rd_uart : in  STD_LOGIC; -- solicita lectura receptor
			  --w_data : in STD_LOGIC_VECTOR(7 downto 0); --dato escrito
			  --wr_uart : in STD_LOGIC; --solicita escritura transmisor
           --r_data : out  STD_LOGIC_VECTOR (7 downto 0); -- dato leido
			  --tx_full: out STD_LOGIC; --bandera lleno transmisor
			  --rx_full : out STD_LOGIC;--bandera lleno receptor
           --rx_empty : out  STD_LOGIC);-- bandera vacio receptor
			  
end TOP_UART;

architecture Behavioral of TOP_UART is
-----------Component----------------------
COMPONENT bRATE_generator
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;          
		tick : OUT std_logic
		);
	END COMPONENT;

COMPONENT FIFO
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		wr : IN std_logic;
		rd : IN std_logic;
		fifo_data_in : IN std_logic_vector(7 downto 0);          
		full : OUT std_logic;
		empty : OUT std_logic;
		fifo_data_out1 : OUT std_logic_vector(7 downto 0);
		fifo_data_out2 : OUT std_logic_vector(7 downto 0);
		fifo_data_out3 : OUT std_logic_vector(7 downto 0);
		fifo_data_out4 : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	COMPONENT FIFO_Transmitter
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		wr : IN std_logic;
		rd : IN std_logic;
		fifo_data_in : IN std_logic_vector(7 downto 0);          
		full : OUT std_logic;
		empty : OUT std_logic;
		fifo_data_out : OUT std_logic_vector(7 downto 0)
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
	COMPONENT Transmitter
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		s_tick : IN std_logic;
		din : IN std_logic_vector(7 downto 0);
		tx_start : IN std_logic;          
		tx : OUT std_logic;
		tx_done : OUT std_logic
		);
	END COMPONENT;
	COMPONENT control_displays
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		empty : IN std_logic;
		full : IN std_logic;
		data_1 : IN std_logic_vector(7 downto 0);
		data_2 : IN std_logic_vector(7 downto 0);
		data_3 : IN std_logic_vector(7 downto 0);
		data_4 : IN std_logic_vector(7 downto 0);          
		rd : OUT std_logic;
		ready : OUT std_logic;
		tiempo_p : OUT std_logic_vector(7 downto 0);
		tiempo_a : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	COMPONENT FSM_HOLA
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		tx_full : IN std_logic;          
		wr : OUT std_logic;
		w_data : OUT std_logic_vector(7 downto 0)
		);
	
	END COMPONENT;	  	
-----------Signal-------------------------
signal tick_connection: std_logic;
signal rxDone_wr : std_logic;
signal dout_wData : std_logic_vector(7 downto 0);
signal rData_din : std_logic_vector(7 downto 0);
signal tx_start_empty,no_empty, tx_done_rd,empty_connection,full_connection,rd_connection : std_logic;
signal data_connection1 : std_logic_vector(7 downto 0);
signal data_connection2 : std_logic_vector(7 downto 0);
signal data_connection3 : std_logic_vector(7 downto 0);
signal data_connection4 : std_logic_vector(7 downto 0);
begin
-------------------Instantiation----------
tx_start_empty <= not no_empty;
Divisor_frecuencia: bRATE_generator PORT MAP(
		clk => clk,
		reset => reset,
		tick => tick_connection
	);
UART_receptor: UART_receiver PORT MAP(
		clk => clk,
		reset => reset,
		rx => rx,
		s_tick => tick_connection,
		rx_done => rxDone_wr,
		dout => dout_wData
	);

Memoria_Receptor: FIFO PORT MAP(
		clk => clk,
		reset => reset,
		wr => rxDone_wr,
		rd => rd_connection,
		fifo_data_in => dout_wData,
		full => full_connection,
		empty => empty_connection,
		fifo_data_out1 => data_connection1,
		fifo_data_out2 => data_connection2,
		fifo_data_out3 => data_connection3,
		fifo_data_out4 => data_connection4
	);
Memoria_Transmisor: FIFO_Transmitter PORT MAP(
		clk => clk,
		reset => reset,
		wr => wr,
		rd => tx_done_rd,
		fifo_data_in => w_data,
		full => tx_full,
		empty => no_empty,
		fifo_data_out => rData_din
	);
Union_numeros : control_displays PORT MAP(
		clk => clk,
		reset => reset,
		empty => empty_connection,
		full => full_connection,
		data_1 => data_connection1,
		data_2 => data_connection2,
		data_3 => data_connection3,
		data_4 => data_connection4,
		rd => rd_connection,
		ready => ready,
		tiempo_p => tiempo_p,
		tiempo_a => tiempo_a
	);
UART_Transmisor: Transmitter PORT MAP(
		clk => clk,
		reset => reset,
		s_tick => tick_connection,
		din => rData_din,
		tx_start => tx_start_empty,
		tx => tx,
		tx_done => tx_done_rd 
	);

end Behavioral;