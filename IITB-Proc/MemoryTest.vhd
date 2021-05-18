library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MemoryTest is
	port (
		clk, wrt: in std_logic;
		addIn, dataIn: in std_logic_vector(15 downto 0);
		dataOut: out std_logic_vector(15 downto 0));
end entity;

architecture arch of MemoryTest is

component Memory is
	port (
		WR: in std_logic;
		addr: in std_logic_vector(15 downto 0); 
		dataIn: in std_logic_vector(15 downto 0); 
		dataOut: out std_logic_vector(15 downto 0));
end component;

signal wr: std_logic;
signal addr, dataA, dataB: std_logic_vector(15 downto 0);

begin

	inst: Memory
		port map (wr, addr, DataA, DataB);

	process(clk)
	begin
		if(rising_edge(clk)) then
			wr <= wrt;
			DataA <= dataIn;
		end if;
		addr <= addIn;
		dataOut <= DataB;
	end process;

end architecture;