-- Written by Gaurav Aggarwal
-- Date: 19th March, 2020
-- Version: v.1.0


LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY SBox IS
		PORT (SBox_in : IN std_logic_vector(127 downto 0);
			 SBox_out : OUT std_logic_vector(127 downto 0));
END SBox;


ARCHITECTURE SBox_logic OF SBox IS

		COMPONENT SBox_slice IS
				PORT(SBox_slice_in : IN std_logic_vector(7 downto 0);
					SBox_slice_out : OUT std_logic_vector(7 downto 0));
		END COMPONENT;

BEGIN
		SB15 : SBox_slice PORT MAP(SBox_in(127 downto 120),SBox_out(127 downto 120)); 
		SB14 : SBox_slice PORT MAP(SBox_in(119 downto 112),SBox_out(119 downto 112));
		SB13 : SBox_slice PORT MAP(SBox_in(111 downto 104),SBox_out(111 downto 104));
		SB12 : SBox_slice PORT MAP(SBox_in(103 downto 96),SBox_out(103 downto 96));
		SB11 : SBox_slice PORT MAP(SBox_in(95 downto 88),SBox_out(95 downto 88)); 
		SB10 : SBox_slice PORT MAP(SBox_in(87 downto 80),SBox_out(87 downto 80));
		SB9 : SBox_slice PORT MAP(SBox_in(79 downto 72),SBox_out(79 downto 72)); 
		SB8 : SBox_slice PORT MAP(SBox_in(71 downto 64),SBox_out(71 downto 64));
		SB7 : SBox_slice PORT MAP(SBox_in(63 downto 56),SBox_out(63 downto 56));
		SB6 : SBox_slice PORT MAP(SBox_in(55 downto 48),SBox_out(55 downto 48));
		SB5 : SBox_slice PORT MAP(SBox_in(47 downto 40),SBox_out(47 downto 40)); 
		SB4 : SBox_slice PORT MAP(SBox_in(39 downto 32),SBox_out(39 downto 32));
		SB3 : SBox_slice PORT MAP(SBox_in(31 downto 24),SBox_out(31 downto 24));
		SB2 : SBox_slice PORT MAP(SBox_in(23 downto 16),SBox_out(23 downto 16));
		SB1 : SBox_slice PORT MAP(SBox_in(15 downto 8),SBox_out(15 downto 8)); 
		SB0 : SBox_slice PORT MAP(SBox_in(7 downto 0),SBox_out(7 downto 0));

END SBox_logic;


