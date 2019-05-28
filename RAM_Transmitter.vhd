library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--Direccion 2^3 = 8
--Datos = 2^3 = 8
entity RAM_Transmitter is
    Port ( clk : in  STD_LOGIC;
           we : in  STD_LOGIC;
           w_addr : in  STD_LOGIC_VECTOR (1 downto 0);
			  r_addr : in  STD_LOGIC_VECTOR (1 downto 0);
           din : in  STD_LOGIC_VECTOR (7 downto 0);
			  dout : out  STD_LOGIC_VECTOR(7  downto 0));
end RAM_Transmitter;

architecture Behavioral of RAM_Transmitter is
type ram_type is array (3 downto 0)
	of std_logic_vector(7 downto 0);
signal ram : ram_type;
begin
	-----Register-------------
	process(clk)
	begin
		if (clk'event and clk = '1') then
			if (we = '1')then
				ram(to_integer(unsigned(w_addr))) <= din;
			end if;
		end if;
	end process;
	dout <= ram(to_integer(unsigned(r_addr)));
end Behavioral;

