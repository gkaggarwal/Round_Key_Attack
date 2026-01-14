-- Written by Gaurav Aggarwal
-- Date: 15th March, 2020
-- Version: v.1.0


LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY RoundkeyAddition IS
		PORT (RoundkeyAddition_in, RoundKey : IN std_logic_vector (127 downto 0);
			 RoundkeyAddition_out : OUT std_logic_vector (127 downto 0));
END RoundkeyAddition;


ARCHITECTURE RoundkeyAddition_logic OF RoundkeyAddition IS
BEGIN

		RoundkeyAddition_out <= RoundkeyAddition_in XOR RoundKey;

END roundkeyaddition_logic;
