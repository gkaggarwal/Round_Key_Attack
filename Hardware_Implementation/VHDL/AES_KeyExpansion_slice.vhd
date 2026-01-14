-- Written by Gaurav Aggarwal
-- Date: 19th March, 2020
-- Version: v.1.0

LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY KeyExpansion_slice IS
		PORT(Encry_load_round : IN std_logic_vector (3 downto 0); 
			 slice_in : IN std_logic_vector(31 downto 0);
			 slice_out : OUT std_logic_vector(31 downto 0));
END KeyExpansion_slice;


ARCHITECTURE KeyExpansion_slice_logic OF KeyExpansion_slice IS
		SIGNAL sig3,sig2,sig1,sig0,temp : std_logic_vector(7 downto 0);

		COMPONENT SBox_slice IS
				PORT(SBox_slice_in : IN std_logic_vector(7 downto 0);
					SBox_slice_out : OUT std_logic_vector(7 downto 0));
		END COMPONENT;

BEGIN
		SB3 : SBox_slice PORT MAP (slice_in(23 downto 16),sig3);
		SB2 : SBox_slice PORT MAP (slice_in(15 downto 8),sig2);
		SB1 : SBox_slice PORT MAP (slice_in(7 downto 0),sig1);
		SB0 : SBox_slice PORT MAP (slice_in(31 downto 24),sig0);

		WITH Encry_load_round SELECT
		                    temp <=		sig3 XOR "00000001"		WHEN "0001",
										sig3 XOR "00000010"		WHEN "0010",
										sig3 XOR "00000100"		WHEN "0011",
										sig3 XOR "00001000"		WHEN "0100",
										sig3 XOR "00010000"		WHEN "0101", 
										sig3 XOR "00100000"		WHEN "0110",
										sig3 XOR "01000000"		WHEN "0111",
										sig3 XOR "10000000"		WHEN "1000",
										sig3 XOR "00011011"		WHEN "1001",
										sig3 XOR "00110110"		WHEN "1010",
										sig3 XOR "00000000"		WHEN OTHERS;

		slice_out(31 downto 24) <= temp;
		slice_out(23 downto 16) <= sig2;
		slice_out(15 downto 8) <= sig1;
		slice_out(7 downto 0) <= sig0;
								
END KeyExpansion_slice_logic;


