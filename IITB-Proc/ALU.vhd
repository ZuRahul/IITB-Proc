library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	port (
		opA : in std_logic_vector(15 downto 0); 
		opB : in std_logic_vector(15 downto 0);
		op : in std_logic;
		output : out std_logic_vector(15 downto 0);
		carry : out std_logic);
end entity;

architecture arch of ALU is 

begin
	process(op,opA,opB)
	begin
		if (op='1') then
			output <= std_logic_vector( to_signed( to_integer(signed(opA)) + to_integer(signed(opB)), output'length ) );
			if ( to_integer(unsigned(opA)) + to_integer(unsigned(opB)) < 2**16 ) then
				carry <= '0';
			else
				carry <= '1';
			end if;
		else
			output <= opA nand opB;
			carry <= '0';
		end if;
	end process;
end architecture;