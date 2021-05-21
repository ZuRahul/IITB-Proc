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
		flagUPD: in std_logic_vector(1 downto 0);
		dataA: out std_logic_vector(15 downto 0);
		dataB: out std_logic_vector(15 downto 0);
		flag: out std_logic_vector(1 downto 0);
		flags: out flg;
		Interface: out d2);
end entity;

architecture arch of RegisterFile is

--type d2 is array (0 to 7) of std_logic_vector (15 downto 0);	--type for buffer
signal store: d2;	--buffer
signal flgs: flg;

begin
	Interface <= store;
	flags <= flgs;
	process(WR,dataC,addA,addB,addC)
		variable addr: natural range 0 to 7;
	begin
		addr := to_integer(unsigned(addC));
		dataA <= store( to_integer(unsigned(addA)) );
		dataB <= store( to_integer(unsigned(addB)) );
		flag <= flgs( addr );
		if (WR='1') then
			store( addr ) <= dataC;
			flgs( addr ) <= flagUPD;
		end if;
	end process;
end architecture;