library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	port (
		opA : in std_logic_vector(15 downto 0); 
		opB : in std_logic_vector(15 downto 0);
		op : in std_logic;
		output : out std_logic_vector(15 downto 0));
end entity;

architecture arch of ALU is 

begin
	process(op,opA,opB)
	begin
		if (op='1') then
			output <= std_logic_vector( to_signed( to_integer(signed(opA)) + to_integer(signed(opB)), output'length ) );
		else
			output <= opA nand opB;
		end if;
	end process;
end architecture;