LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY InterruptUnit IS
	PORT(	Clk : IN std_logic;
		IsPipeLineStalled : IN std_logic;
		IntRequest : IN  std_logic;
		Reset : IN std_logic;
		LoadFromID : IN std_logic;
		JmpCallFromID : IN std_logic;
		JmpTypeFromID : IN std_logic_vector(1 downto 0);
		RetFromID : IN std_logic;
		RtiFromID : IN std_logic;
		JmpTypeFromEx : IN std_logic_vector (1 downto 0);
		RetFromEx: IN std_logic;
		RtiFromEx: IN std_logic;
		RetFromMem: IN std_logic;
		RtiFromMem: IN std_logic;
		IntInstr : OUT std_logic_vector(15 downto 0);
		PcPcMinus : OUT  std_logic;
		FlushExecute : OUT std_logic;
		IntOut : OUT std_logic );
END InterruptUnit;

ARCHITECTURE a_InterruptUnit of InterruptUnit IS


	BEGIN
	IntInstr <= "1111000011000000";
	Process(Clk, IntRequest, IsPipeLineStalled,
 		Reset, LoadFromID,
 		JmpCallFromID, JmpTypeFromID,
 		RetFromID, RtiFromID, JmpTypeFromEx,
 		RetFromEx, RtiFromEx,
 		RetFromMem, RtiFromMem)
variable InterruptReceived, Interrupted, IntOutInternal: std_logic := '0'; 
	BEGIN

		If(IntRequest = '1' AND Interrupted = '0') THEN
			 InterruptReceived := '1';
			END IF;
		If( InterruptReceived = '1' AND Interrupted = '0' AND IsPipeLineStalled = '0' AND JmpCallFromID = '0' AND JmpTypeFromID = "00" AND RetFromID = '0' AND RtiFromID= '0' AND JmpTypeFromEx = "00" AND RetFromEx = '0' AND RtiFromEx ='0' AND RetFromMem = '0' AND RtiFromMem = '0' ) THEN
				IntOut <= '1';
				IntOutInternal := '1';
			END IF;
		If( LoadFromID = '1' AND IntOutInternal = '1') THEN
			PcPcMinus <= '1';
			FlushExecute <= '1';
			END IF;
		If( rising_edge(Clk) AND IntOutInternal = '1' )THEN
			Interrupted := '1';
			InterruptReceived := '0';
			IntOutInternal := '0';
			IntOut <= '0';
			PcPcMinus <= '0';
			FlushExecute <= '0';
			END IF;
		If (Reset = '1') THEN
			Interrupted := '0';
			InterruptReceived := '0';
			IntOut <= '0';
			IntOutInternal := '0';
			PcPcMinus <= '0';
			FlushExecute <= '0';
			END IF;
		If (RtiFromMem = '1' AND rising_edge(Clk)) THEN
			Interrupted := '0';
			InterruptReceived := '0';
			IntOut <= '0';
			IntOutInternal := '0';
			PcPcMinus <= '0';
			FlushExecute <= '0';
			END IF;
		
	END PROCESS;
END a_InterruptUnit;