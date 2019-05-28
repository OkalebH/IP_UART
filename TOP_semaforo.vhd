library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP_semaforo is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  ready : in STD_LOGIC;
			  tvp : IN std_logic_vector(7 downto 0);
			  tva : IN std_logic_vector(7 downto 0);
			  bt : IN std_logic;          
			  sp : OUT std_logic_vector(1 downto 0);
			  sa : OUT std_logic_vector(2 downto 0));
end TOP_semaforo;

architecture Behavioral of TOP_semaforo is
------------COMPONENT---------------------
COMPONENT maquina_semaforo
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		ready : IN std_logic;
		tvp : IN std_logic_vector(7 downto 0);
		tva : IN std_logic_vector(7 downto 0);
		bt : IN std_logic;          
		sp : OUT std_logic_vector(1 downto 0);
		sa : OUT std_logic_vector(2 downto 0)
		);
	END COMPONENT;
COMPONENT segundero
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;          
		tick : OUT std_logic
		);
	END COMPONENT;

------------SIGNAL------------------------
signal clk_connection : STD_LOGIC;
begin
------------INSTANTIATION-----------------
Control_semaforo: maquina_semaforo PORT MAP(
		clk => clk_connection,
		reset => reset,
		ready => ready,
		tvp => tvp,
		tva => tva,
		bt => bt,
		sp => sp,
		sa => sa
	);
Divisor_Frecuencia : segundero PORT MAP(
		clk => clk,
		reset => reset,
		tick => clk_connection
	);
end Behavioral;

