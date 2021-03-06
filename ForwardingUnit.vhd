LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY ForwardingUnit IS
	PORT(JmpCallFromId : In std_logic;
		RsFromId : In std_logic_vector(2 downto 0);
		RtFromId : In std_logic_vector(2 downto 0);
		RsFromEx : In std_logic_vector(2 downto 0);
		RtFromEx : In std_logic_vector(2 downto 0);
		RdFromEx : In std_logic_vector(2 downto 0);

		NeedRsFromId : In std_logic;
		NeedRtFromId : In std_logic;

		NeedRsFromEx : In std_logic;
		NeedRtFromEx : In std_logic;
		
		RdFromMem: In std_logic_vector(2 downto 0);
		RdFromWb: In std_logic_vector(2 downto 0);
		
		RegWriteFromEx: In std_logic;
		XToRegFromEx: In std_logic_vector(1 downto 0);

		RegWriteFromMem: In std_logic;
		XToRegFromMem: In std_logic_vector(1 downto 0);

		RegWriteFromWb: In std_logic;
		XToRegFromWb: In std_logic_vector(1 downto 0);

		ALUResFromMem: In std_logic_vector(15 downto 0);
		ImmFromMem: In std_logic_vector(15 downto 0);

		ALUResFromWb: In std_logic_vector(15 downto 0);
		ImmFromWb: In std_logic_vector(15 downto 0);
		MemDataFromWb: In std_logic_vector(15 downto 0);
		
		StallPc: Out std_logic;
		StallIfId: Out std_logic;
		FlushIdEx: Out std_logic;
		
		ForwardToId: Out std_logic;
		RsToId: Out std_logic_vector(15 downto 0);
		
		ForwardRsToEx: Out std_logic;
		ForwardRtToEx: Out std_logic;
		RsToEx: Out std_logic_vector(15 downto 0);
		RtToEx: Out std_logic_vector(15 downto 0));
	
END ForwardingUnit;

ARCHITECTURE a_ForwardingUnit of ForwardingUnit IS


BEGIN

	Process(JmpCallFromId, RsFromId, RtFromId, RsFromEx, RtFromEx, RdFromEx, NeedRsFromId, NeedRtFromId, NeedRsFromEx, NeedRtFromEx, 
		RdFromMem, RdFromWb, RegWriteFromEx, XToRegFromEx,
		RegWriteFromMem, XToRegFromMem, RegWriteFromWb, XToRegFromWb, ALUResFromMem, ImmFromMem, ALUResFromWb,
		ImmFromWb, MemDataFromWb)
		Begin
		If(JmpCallFromId = '1' And (RdFromEx = RsFromId) And RegWriteFromEx = '1') THEN
			StallPc <= '1';
			StallIfId <= '1';
			FlushIdEx <= '1';
			ForwardToId <= '0';
			RsToId <= "0000000000000000";
		ELSIF(JmpCallFromId = '1' AND (RdFromMem = RsFromId) AND RegWriteFromMem = '1' AND XToRegFromMem = "01") THEN
			StallPc <= '0';
			StallIfId <= '0';
			FlushIdEx <= '0';
			ForwardToId <= '1';
			RsToId <= ALUResFromMem;
		ELSIF(JmpCallFromId = '1' AND (RdFromMem = RsFromId) AND RegWriteFromMem = '1' AND XToRegFromMem = "10") THEN
			StallPc <= '0';
			StallIfId <= '0';
			FlushIdEx <= '0';
			ForwardToId <= '1';
			RsToId <= ImmFromMem;
		ELSIF(JmpCallFromId = '1' AND (RdFromMem = RsFromId) AND RegWriteFromMem = '1' AND XToRegFromMem = "00") THEN
			StallPc <= '1';
			StallIfId <= '1';
			FlushIdEx <= '1';
			ForwardToId <= '0';
			RsToId <= "0000000000000000";

		ELSIF(NeedRsFromId = '1' AND RdFromEx = RsFromId AND RegWriteFromEx = '1' AND XToRegFromEx = "00") THEN
			StallPc <= '1';
			StallIfId <= '1';
			FlushIdEx <= '1';
			ForwardToId <= '0';
			RsToId <= "0000000000000000";
		ELSIF(NeedRtFromId = '1' AND (RdFromEx = RtFromId) AND RegWriteFromEx = '1' AND XToRegFromEx = "00") THEN
			StallPc <= '1';
			StallIfId <= '1';
			FlushIdEx <= '1';
			ForwardToId <= '0';
			RsToId <= "0000000000000000";
		ELSE
			StallPc <= '0';
			StallIfId <= '0';
			FlushIdEx <= '0';
			ForwardToId <= '0';
			RsToId <= "0000000000000000"; 
		END IF;

		--IF(NeedRsFromEx = '1' AND (RdFromMem = RsFromEx) AND RegWriteFromMem = '1' AND XToRegFromMem = "00") THEN --ThisCaseShouldNeverHappenInMemStage
			--ForwardRsToEx <= '1';
			--RsToEx <= MemDataFromMem;
		IF(NeedRsFromEx = '1' AND (RdFromMem = RsFromEx) And RegWriteFromMem = '1' AND XToRegFromMem = "01") THEN
			ForwardRsToEx <= '1';
			RsToEx <= ALUResFromMem;
		ELSIF(NeedRsFromEx = '1' AND (RdFromMem = RsFromEx) And RegWriteFromMem = '1' AND XToRegFromMem = "10") THEN
			ForwardRsToEx <= '1';
			RsToEx <= ImmFromMem;

		ELSIF(NeedRsFromEx = '1' AND (RdFromWb = RsFromEx) And RegWriteFromWb = '1' AND XToRegFromWb = "00") THEN
			ForwardRsToEx <= '1';
			RsToEx <= MemDataFromWb;
		ELSIF(NeedRsFromEx = '1' AND (RdFromWb = RsFromEx) And RegWriteFromWb = '1' AND XToRegFromWb = "01") THEN
			ForwardRsToEx <= '1';
			RsToEx <= ALUResFromWb;
		ELSIF(NeedRsFromEx = '1' AND (RdFromWb = RsFromEx) And RegWriteFromWb = '1' AND XToRegFromWb = "10") THEN
			ForwardRsToEx <= '1';
			RsToEx <= ImmFromWb;
		ELSE
			ForwardRsToEx <= '0';
			RsToEx <= "0000000000000000";
		END IF;

		IF(NeedRtFromEx = '1' AND (RdFromMem = RtFromEx) And RegWriteFromMem = '1' AND XToRegFromMem = "01") THEN
			ForwardRtToEx <= '1';
			RtToEx <= ALUResFromMem;
		ELSIF(NeedRtFromEx = '1' AND (RdFromMem = RtFromEx) And RegWriteFromMem = '1' AND XToRegFromMem = "10") THEN
			ForwardRtToEx <= '1';
			RtToEx <= ImmFromMem;

		ELSIF(NeedRtFromEx = '1' AND (RdFromWb = RtFromEx) And RegWriteFromWb = '1' AND XToRegFromWb = "00") THEN
			ForwardRtToEx <= '1';
			RtToEx <= MemDataFromWb;
		ELSIF(NeedRtFromEx = '1' AND (RdFromWb = RtFromEx) And RegWriteFromWb = '1' AND XToRegFromWb = "01") THEN
			ForwardRtToEx <= '1';
			RtToEx <= ALUResFromWb;
		ELSIF(NeedRtFromEx = '1' AND (RdFromWb = RtFromEx) And RegWriteFromWb = '1' AND XToRegFromWb = "10") THEN
			ForwardRtToEx <= '1';
			RtToEx <= ImmFromWb;
		ELSE
			ForwardRtToEx <= '0';
			RtToEx <= "0000000000000000";
		END IF;

	End Process;
-- IF JMP/Call AND Rd of Id/Ex == Rs and RegWrite , stall and flush ID/Ex
-- ELSE if Rd of Ex/Mem = Rs AND RegWrite and XtoReg is ALU, forward ALU
-- ELSE if Rd of Ex/Mem = Rs AND RegWrite and XtoReg is IMM, forward IMM
-- ELSE if Rd of Ex/Mem = Rs AND RegWrite and XtoReg is MEM, stall and flush Id/Ex
-- ELSE if Rd of Mem/Wb = Rs AND RegWrite and XtoReg is ALU, forward ALU 
-- ELSE if Rd of Mem/Wb = Rs AND RegWrite and XtoReg is IMM, forward IMM 
-- ELSE if Rd of Mem/Wb = Rs AND RegWrite and XtoReg is MEM, forward MEM 
-- ELSE no flushing, no forwarding.
	

END a_ForwardingUnit;