library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--Direccion 2^3 = 8
--Datos = 2^3 = 8
entity RAM is
    Port ( clk : in  STD_LOGIC;
           we : in  STD_LOGIC;
           w_addr : in  STD_LOGIC_VECTOR (1 downto 0);
			  r_addr : in  STD_LOGIC_VECTOR (1 downto 0);
           din : in  STD_LOGIC_VECTOR (7 downto 0);
			  dout1 : out  STD_LOGIC_VECTOR(7  downto 0);
			  dout2 : out  STD_LOGIC_VECTOR(7  downto 0);
			  dout3 : out  STD_LOGIC_VECTOR(7  downto 0);
           dout4 : out  STD_LOGIC_VECTOR(7  downto 0));
end RAM;

architecture Behavioral of RAM is
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
	--dout1 <= ram(to_integer(unsigned(r_addr)));
	dout1 <= ram(0);
	dout2 <= ram(1);
	dout3 <= ram(2);
	dout4 <= ram(3);
end Behavioral;

