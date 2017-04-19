LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY dataMem IS

	PORT(
		CLK : IN STD_LOGIC;
		MEMWR  : IN STD_LOGIC;
		-- 1kB
		ADDRESS : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		DATAIN  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		DATAOUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));

END ENTITY dataMem;


ARCHITECTURE dataMemArch OF dataMem IS
	
	TYPE RAM_TYPE IS ARRAY(0 TO 1023) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL DATAMEMORY : RAM_TYPE;

	BEGIN
		PROCESS(CLK) IS -- WRITE ON RISING EDGE (Sync.)
			BEGIN
				IF RISING_EDGE(CLK) THEN
					IF MEMWR = '1' THEN
						DATAMEMORY (TO_INTEGER(UNSIGNED(ADDRESS))) <= DATAIN;
					END IF;
				END IF;
		END PROCESS;
		
		DATAOUT <= DATAMEMORY (TO_INTEGER(UNSIGNED(ADDRESS))); -- Async.

END dataMemArch;