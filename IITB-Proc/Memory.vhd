library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory is
	port (
		WR: in std_logic;
		addr: in std_logic_vector(15 downto 0); 
		dataIn: in std_logic_vector(15 downto 0); 
		dataOut: out std_logic_vector(15 downto 0));
end entity;

architecture arch of Memory is

type d2 is array (0 to 2**16-1) of std_logic_vector (15 downto 0);	--type for file
signal store: d2;	--file

begin
	process(WR,dataIn,addr)
	variable RAM_ADDR_IN: natural range 0 to 2**16-1;
	begin
		RAM_ADDR_IN := to_integer(UNSIGNED(addr)); 
		dataOut <= store( RAM_ADDR_IN );
		if (WR='1') then
			store( RAM_ADDR_IN ) <= dataIn;
		end if;
	end process;
end architecture;