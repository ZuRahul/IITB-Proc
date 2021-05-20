library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.utilities.all;

entity RegisterFile is
	port (
		WR: in std_logic;
		addA: in std_logic_vector(2 downto 0); 
		addB: in std_logic_vector(2 downto 0); 
		addC: in std_logic_vector(2 downto 0); 
		dataC: in std_logic_vector(15 downto 0); 
		dataA: out std_logic_vector(15 downto 0);
		dataB: out std_logic_vector(15 downto 0);
		Interface: out d2 );
end entity;

architecture arch of RegisterFile is

--type d2 is array (0 to 7) of std_logic_vector (15 downto 0);	--type for buffer
signal store: d2;	--buffer

begin
	Interface <= store;
	process(WR,dataC,addA,addB,addC)
	begin
		dataA <= store( to_integer(unsigned(addA)) );
		dataB <= store( to_integer(unsigned(addB)) );
		if (WR='1') then
			store( to_integer(unsigned(addC)) ) <= dataC;
		end if;
	end process;
end architecture;