library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity segundero is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           tick : out  STD_LOGIC);
end segundero;

architecture Behavioral of segundero is
	signal tick_next, tick_reg : unsigned(25 downto 0);
begin
-----REGISTER-----
process(clk,reset)
begin
	if(reset = '0') then
		tick_reg <= (others => '0');
	elsif(clk'event and clk = '1') then
		tick_reg <= tick_next;
	end if;
end process;
tick_next <= (others => '0') when (tick_reg = 50000000) else tick_reg + 1;

tick <= '1' when tick_reg = 50000000 else '0';



end Behavioral;

