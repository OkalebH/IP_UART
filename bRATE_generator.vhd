Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bRATE_generator is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           tick : out  STD_LOGIC);
end bRATE_generator;

architecture Behavioral of bRATE_generator is
signal s_next, s_reg : unsigned(7 downto 0);
begin
-----------------Registro--------------------
	process(clk,reset)
	begin
		if reset = '0' then
			s_reg <= (others => '0');
		elsif(clk'event and clk = '1') then
			s_reg <= s_next;
		end if;
	end process;
-----------------Logica Estado Siguiente-----
	s_next <= (others => '0') when (s_reg = 163) else s_reg + 1;
	tick <= '1' when s_reg = 163 else '0';

end Behavioral;

