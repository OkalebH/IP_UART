Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIFO_Controller is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           rd : in  STD_LOGIC;
           wr : in  STD_LOGIC;
           full : out  STD_LOGIC;
           empty : out  STD_LOGIC;
           w_addr : out  STD_LOGIC_VECTOR(1 downto 0);--Direccion: 00 
           r_addr : out STD_LOGIC_VECTOR(1 downto 0));--Direccion: 00
end FIFO_Controller;

architecture Behavioral of FIFO_Controller is
constant N : natural := 2;
signal w_ptr_reg, w_ptr_next : unsigned(N downto 0);
signal r_ptr_reg, r_ptr_next : unsigned(N downto 0);
signal full_flag, empty_flag : std_logic;
begin
-----------------Registro---------------------------
	process(clk,reset)
	begin
		if reset = '0' then
			w_ptr_reg <= (others => '0');
			r_ptr_reg <= (others => '0');
		elsif (clk'event and clk = '1') then
			w_ptr_reg <= w_ptr_next;
			r_ptr_reg <= r_ptr_next;
		end if;
	end process;
---------------Write pointer next state logic-------
	w_ptr_next <= 
		w_ptr_reg + 1 when (wr = '1' and full_flag = '0') else 
		w_ptr_reg;
	full_flag <=
		'1' when (r_ptr_reg(N) /= w_ptr_reg(N) and r_ptr_reg(N-1 downto 0) = w_ptr_reg(N-1 downto 0)) else
		'0';
---------------Write port output--------------------
	w_addr <= std_logic_vector(w_ptr_reg(N-1 downto 0)); --*
	full <= full_flag;
---------------Read pointer next state logic--------
	r_ptr_next <= 
		r_ptr_reg + 4 when (rd = '1' and empty_flag = '0') else
		r_ptr_reg;
	empty_flag <= '1' when r_ptr_reg = w_ptr_reg else
		'0';
---------------Read port output---------------------
	r_addr <= std_logic_vector(r_ptr_reg(N-1 downto 0)); --*
	empty <= empty_flag;

end Behavioral;

