LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY RF_TB IS
END RF_TB;

ARCHITECTURE BEHAVIOUR OF RF_TB IS

COMPONENT RFTest is
	port (
		clk, wrt: in std_logic;
		addIn, addOut: in std_logic_vector(2 downto 0);
		dataIn: in std_logic_vector(15 downto 0);
		dataOut: out std_logic_vector(15 downto 0));
		
end COMPONENT;

SIGNAL CLK, WRT : STD_LOGIC := '0';
SIGNAL ADDIN, ADDOUT: STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL DATAIN, DATAOUT: STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

	TEST_INST: RFTest
		PORT MAP (CLK, WRT, ADDIN, ADDOUT, DATAIN, DATAOUT);
		
	PROCESS
	
	BEGIN
		
		CLK <= '0';
		WAIT FOR 100 NS;
		
		CLK<= '1';
		WRT <= '1';
		ADDIN <= "001";
		DATAIN <= "1000100010001000";
		WAIT FOR 100 NS;
		
		CLK <= '0';
		WAIT FOR 100 NS;
		
		CLK <= '1';
		WRT <= '0';
		ADDOUT <= "001";
		WAIT FOR 100 NS;
		
	END PROCESS;

END ARCHITECTURE; 