library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.utilities.all;

entity RFTest is
	port (
		clk, wrt: in std_logic;
		addIn, addOut: in std_logic_vector(2 downto 0);
		dataIn: in std_logic_vector(15 downto 0);
		dataOut: out std_logic_vector(15 downto 0);
		Interface: out d2);
end entity;

architecture arch of RFTest is

component RegisterFile is
	port (
		WR: in std_logic;
		addA: in std_logic_vector(2 downto 0); 
		addB: in std_logic_vector(2 downto 0); 
		addC: in std_logic_vector(2 downto 0); 
		dataC: in std_logic_vector(15 downto 0); 
		dataA: out std_logic_vector(15 downto 0);
		dataB: out std_logic_vector(15 downto 0);
		Interface: out d2);
end component;

signal wr: std_logic;
signal addA, addB, addC: std_logic_vector(2 downto 0); 
signal dataA, dataB, dataC: std_logic_vector(15 downto 0);

begin

	inst: RegisterFile
		port map (wr, addA, addB, addC, dataC, dataA, dataB, Interface);

	process(clk)
	begin
		if(rising_edge(clk)) then
			wr <= wrt;
			addC <= addIn;
			dataC <= dataIn;
		end if;
		addA <= addOut;
		dataOut <= dataA;
	end process;

end architecture;