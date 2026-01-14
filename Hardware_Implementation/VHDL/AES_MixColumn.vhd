-- Written by Gaurav Aggarwal
-- Date: 16th March, 2020
-- Version: v.1.0


LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY MixColumn IS
		PORT(MixColumn_in : IN std_logic_vector (127 downto 0);
			MixColumn_out : OUT std_logic_vector (127 downto 0));
END MixColumn;


ARCHITECTURE MixColumn_logic OF MixColumn IS

		COMPONENT MixColumn_slice IS
				PORT(slice3_in, slice2_in, slice1_in, slice0_in : IN std_logic_vector (7 downto 0);
				slice3_out, slice2_out, slice1_out, slice0_out : OUT std_logic_vector (7 downto 0));
		END COMPONENT;

BEGIN
		M3 : MixColumn_slice PORT MAP(MixColumn_in(127 downto 120), MixColumn_in(119 downto 112),
		MixColumn_in(111 downto 104), MixColumn_in(103 downto 96), MixColumn_out(127
		downto 120), MixColumn_out(119 downto 112), MixColumn_out(111 downto 104),
		MixColumn_out(103 downto 96));

		M2 : MixColumn_slice PORT MAP(MixColumn_in(95 downto 88), MixColumn_in(87 downto 80),
		MixColumn_in(79 downto 72), MixColumn_in(71 downto 64), MixColumn_out(95 downto
		88), MixColumn_out(87 downto 80), MixColumn_out(79 downto 72), MixColumn_out(71
		downto 64));

		M1 : MixColumn_slice PORT MAP(MixColumn_in(63 downto 56), MixColumn_in(55 downto 48),
		MixColumn_in(47 downto 40), MixColumn_in(39 downto 32), MixColumn_out(63 downto
		56), MixColumn_out(55 downto 48), MixColumn_out(47 downto 40), MixColumn_out(39
		downto 32));

		M0 : MixColumn_slice PORT MAP(MixColumn_in(31 downto 24), MixColumn_in(23 downto 16),
		MixColumn_in(15 downto 8), MixColumn_in(7 downto 0), MixColumn_out(31 downto
		24), MixColumn_out(23 downto 16), MixColumn_out(15 downto 8), MixColumn_out(7
		downto 0));

END MixColumn_logic;










