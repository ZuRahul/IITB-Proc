library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUTest is
	port (
		clk, op: in std_logic;
		opA, opB: in std_logic_vector(15 downto 0);
		output: out std_logic_vector(15 downto 0));
end entity;

architecture arch of ALUTest is

component ALU is
	port (
		opA : in std_logic_vector(15 downto 0); 
		opB : in std_logic_vector(15 downto 0);
		op : in std_logic;
		output : out std_logic_vector(15 downto 0));
end component;

signal oper: std_logic;
signal op1, op2: std_logic_vector(15 downto 0);

begin

	inst: ALU
		port map (op1, op2, oper, output);
	
	process(clk)
	begin
		if(rising_edge(clk)) then
			oper <= op;
			op1 <= opA;
			op2 <= opB;
		end if;
	end process;

end architecture;