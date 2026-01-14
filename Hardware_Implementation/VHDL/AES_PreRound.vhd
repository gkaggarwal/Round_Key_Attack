-- Written by Gaurav Aggarwal
-- Date: 11th March, 2020
-- Version: v1.0


LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY pre_round IS
		PORT (plain_text : IN std_logic_vector (127 downto 0);
		encry_key : IN std_logic_vector (127 downto 0);
		pre_round_out : OUT std_logic_vector (127 downto 0));
END pre_round;

ARCHITECTURE pre_round_logic OF pre_round IS
BEGIN
		pre_round_out <= plain_text XOR encry_key;
END pre_round_logic;

		

