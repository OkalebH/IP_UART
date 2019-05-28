library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP_PROYECTO is
	Port ( clk : in  STD_LOGIC;
          reset : in  STD_LOGIC;
			 rx : IN std_logic;          
			 tx : OUT std_logic;  
			 bt : IN std_logic;          
			 sp : OUT std_logic_vector(1 downto 0);
			 sa : OUT std_logic_vector(2 downto 0));
end TOP_PROYECTO;

architecture Behavioral of TOP_PROYECTO is
---------------COMPONENT------------------
COMPONENT TOP_UART
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		rx : IN std_logic;
		wr : IN std_logic;
		w_data : IN std_logic_vector(7 downto 0);          
		tx : OUT std_logic;
		ready : OUT std_logic;
		tx_full : OUT std_logic;
		tiempo_p : OUT std_logic_vector(7 downto 0);
		tiempo_a : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	COMPONENT maquina_semaforo
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		ready : IN std_logic;
		tvp : IN std_logic_vector(7 downto 0);
		tva : IN std_logic_vector(7 downto 0);
		tx_full : IN std_logic;
		bt : IN std_logic;          
		wr : OUT std_logic;
		w_data : OUT std_logic_vector(7 downto 0);
		sp : OUT std_logic_vector(1 downto 0);
		sa : OUT std_logic_vector(2 downto 0)
		);
	END COMPONENT;
---------------SIGNAL---------------------
signal ready_connection : STD_LOGIC;
signal tiempo_p_cn : std_logic_vector(7 downto 0);
signal tiempo_a_cn : std_logic_vector(7 downto 0);
signal tx_full_cn : std_logic;
signal wr_cn : std_logic;
signal w_data_cn : std_logic_vector(7 downto 0);
begin
---------------INSTATIATION---------------

Inst_TOP_UART: TOP_UART PORT MAP(
		clk => clk,
		reset => reset,
		rx => rx,
		tx => tx,
		ready => ready_connection,
		tx_full => tx_full_cn,
		wr => wr_cn,
		w_data => w_data_cn,
		tiempo_p => tiempo_p_cn,
		tiempo_a => tiempo_a_cn
	);
	
	Inst_maquina_semaforo: maquina_semaforo PORT MAP(
		clk => clk,
		reset => reset,
		ready => ready_connection,
		tvp => tiempo_p_cn,
		tva => tiempo_a_cn,
		tx_full => tx_full_cn,
		wr => wr_cn,
		w_data => w_data_cn,
		bt => bt,
		sp => sp,
		sa => sa
	);

end Behavioral;

