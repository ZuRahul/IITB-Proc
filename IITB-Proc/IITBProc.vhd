library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IITBProc is
	port( 
		clk, load: in std_logic;
		DataIn: in std_logic_vector(15 downto 0));
end entity;

architecture arch of IITBProc is

component RegisterFile is
	port (
		WR: in std_logic;
		addA: in std_logic_vector(2 downto 0); 
		addB: in std_logic_vector(2 downto 0); 
		addC: in std_logic_vector(2 downto 0); 
		dataC: in std_logic_vector(15 downto 0); 
		dataA: out std_logic_vector(15 downto 0);
		dataB: out std_logic_vector(15 downto 0));
end component;

component Memory is
	port (
		WR: in std_logic;
		addr: in std_logic_vector(15 downto 0); 
		dataIn: in std_logic_vector(15 downto 0); 
		dataOut: out std_logic_vector(15 downto 0));
end component;

component ALU is
	port (
		opA : in std_logic_vector(15 downto 0); 
		opB : in std_logic_vector(15 downto 0);
		op : in std_logic;
		output : out std_logic_vector(15 downto 0));
end component;

signal IR,PC,MemAddr,MemDataIn,MemDataOut,DataA,DataB,DataC,opA,opB,ALUout: std_logic_vector(15 downto 0) := "0000000000000000";
signal MemWR,RegWR,op: std_logic;
signal addA,addB,addC: std_logic_vector(2 downto 0) := "000";

signal state: natural range 0 to 40;

begin

	Arithmetic: ALU
		port map (opA,opB,op,ALUout);
	
	RAM: Memory
		port map (MemWR,MemAddr,MemDataIn,MemDataOut);
	
	Registers: RegisterFile
		port map (RegWR,addA,addB,addC,DataC,DataA,DataB);

	process(clk)
		variable loadAddr: std_logic_vector(15 downto 0) := "0000000000000000";
	begin
		if (rising_edge(clk)) then
			
			if (load='1') then
				MemWR <= '1';
				RegWR <= '0';
				MemAddr <= loadAddr;
				MemDataIn <= DataIn;
				loadAddr := std_logic_vector( to_signed( to_integer(signed(loadAddr)) + 1, loadAddr'length ) );
			else
			
				if (state=0) then
					MemWR <= '0';
					RegWR <= '0';
					MemAddr <= PC;
					IR <= MemDataOut;
					op <= '1';
					opA <= "0000000000000001";
					opB <= PC;
					state <= 1;
				
				
				elsif (state=1) then
					if (IR(15 downto 12)="0000") or (IR(15 downto 12)="0010") then
						state <= 2; --R
					elsif (IR(15 downto 12)="0011") or (IR(15 downto 12)="0110") or (IR(15 downto 12)="0111") then
						state <= 4; --J
					else
						state <= 3; --I
					end if;
				
				
				elsif (state=2) then	--R
					addA <= IR(11 downto 9);
					addB <= IR(8 downto 6);
					addC <= IR(5 downto 3);
					if (IR(13)='1') then
						state <= 6;
					else
						state <= 5;
					end if;
					PC <= ALUout;
		
				
				elsif (state=3) then --I
					addA <= IR(11 downto 9);
					addB <= IR(8 downto 6);
					if (IR(15 downto 14)="00") then
						state <= 8;
					elsif (IR(15 downto 14)="01") then
						state <= 9;
					else
						state <= 17;
					end if;
				
				
				elsif (state=4) then --J
					addA <= IR(11 downto 9);
					addB <= "000";
					if (IR(14)='0') then
						state <= 18;
					elsif (IR(12)='1') then
						state <= 19; --SA
					else
						state <= 27; --LA
					end if;
					PC <= ALUout;
				
				elsif (state=5) then --Add
					opA <= DataA;
					opB <= DataB;
					op <= '1';
					state <= 7;
					
					
				elsif (state=6) then --Nand
					opA <= DataA;
					opB <= DataB;
					op <= '0';
					state <= 7;
				
				
				elsif (state=7) then --ALU Update
					RegWR <= '1';
					DataC <= ALUout;
					state <= 0;
				
				
				elsif (state=8) then --Add Immediate
					PC <= ALUout;
					opB <= std_logic_vector( resize( signed(IR(5 downto 0)), opB'length ) );
					opA <=  DataB;
					addC <= addA;
					op <= '1';
					state <= 7;
				
				
				elsif (state=9) then --Load/Store
					PC <= ALUout;
					opB <= std_logic_vector( resize( signed(IR(5 downto 0)), opB'length ) );
					opA <= DataA;
					op <= '1';
					if (IR(12)='1') then
						state <= 11;
					else
						state <= 10;
					end if;
				
				
				elsif (state=10) then
					MemAddr <= ALUout;
					state <= 12;
				
				elsif (state=11) then
					MemAddr <= ALUout;
					MemDataIn <= DataB;
					MemWR <= '1';
					state <= 0;
				
				elsif (state=12) then
					DataC <= MemDataOut;
					addC <= addB;
					RegWR <= '1';
					state <= 0;
					
				elsif (state=13) then
					addC <= addA;
					DataC <= PC;
					RegWR <= '1';
					if (IR(12)='1') then
						state <= 16;
					else
						state <= 15;
					end if;
				
				elsif (state=14) then
					if (DataA=DataB) then
						PC <= ALUout;
					else
						PC <= std_logic_vector(to_unsigned(to_integer(unsigned(PC))+1, PC'length));
					end if;
					state <= 0;
					
				elsif (state=15) then
					PC <= ALUout;
					state <= 0;
				
				elsif (state=16) then
					PC <= DataB;
					state <= 0;
				
				elsif (state=17) then
					opA <= PC;
					opB <= std_logic_vector( resize( signed(IR(5 downto 0)), opB'length ) );
					if (IR(14)='1') then
						state <= 14;
					else
						state <= 13;
					end if;
				
				elsif (state=18) then
					DataC(15 downto 7) <= IR(8 downto 0);
					DataC(6 downto 0) <= "0000000";
					addC <= addA;
					RegWR <= '1';
					state <= 0;
				
				elsif (state=19) then
					opA <= DataA;
					opB <= "0000000000000001";
					op <= '1';
					MemAddr <= DataA;
					MemDataIn <= DataB;
					MemWR <= '1';
					state <= 20;
					addB <= "001";
				
				elsif (state < 27) then
					addB <= std_logic_vector(to_unsigned(to_integer(unsigned(addB))+1, addB'length));
					MemAddr <= ALUout;
					MemDataIn <= DataB;
					opA <= ALUout;
					if (state=26) then
						state <= 0;
					else
						state <= state+1;
					end if;
				
				elsif (state=27) then
					opA <= DataA;
					opB <= "0000000000000001";
					op <= '1';
					MemWR <= '0';
					addC <= "111";
					MemAddr <= DataA;
					state <= 28;
				
				elsif (state<36) then
					opA <= ALUout;
					addC <= std_logic_vector(to_unsigned(to_integer(unsigned(addC))+1, addC'length));
					DataC <= MemDataOut;
					MemAddr <= ALUout;
					RegWR <= '1';
					if (state=35) then
						state <= 0;
					else
						state <= state+1;
					end if;
				
				end if;
			
			end if;
			
		end if;
	end process;

end architecture;