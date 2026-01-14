-- Written by Gaurav Aggarwal
-- Date: 15th March, 2020
-- Version: v.1.0


LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY shiftrows IS
		PORT (shiftrows_in : IN std_logic_vector (127 downto 0);
			 shiftrows_out : OUT std_logic_vector(127 downto 0));
END shiftrows;


ARCHITECTURE shiftrows_logic OF shiftrows IS
BEGIN
		shiftrows_out (127 downto 120) <= shiftrows_in (127 downto 120);
		shiftrows_out (119 downto 112) <= shiftrows_in (87 downto 80);
		shiftrows_out (111 downto 104) <= shiftrows_in (47 downto 40);
		shiftrows_out (103 downto 96) <= shiftrows_in (7 downto 0);

		shiftrows_out (95 downto 88) <= shiftrows_in (95 downto 88);
		shiftrows_out (87 downto 80) <= shiftrows_in (55 downto 48);
		shiftrows_out (79 downto 72) <= shiftrows_in (15 downto 8);
		shiftrows_out (71 downto 64) <= shiftrows_in (103 downto 96);

		shiftrows_out (63 downto 56) <= shiftrows_in (63 downto 56);
		shiftrows_out (55 downto 48) <= shiftrows_in (23 downto 16);
		shiftrows_out (47 downto 40) <= shiftrows_in (111 downto 104);
		shiftrows_out (39 downto 32) <= shiftrows_in (71 downto 64);

		shiftrows_out (31 downto 24) <= shiftrows_in (31 downto 24);
		shiftrows_out (23 downto 16) <= shiftrows_in (119 downto 112);
		shiftrows_out (15 downto 8) <= shiftrows_in (79 downto 72);
		shiftrows_out (7 downto 0) <= shiftrows_in (39 downto 32);
END shiftrows_logic;


