-- Written by Gaurav Aggarwal
-- Date: 19th March, 2020
-- Version: v.1.0


LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY MixColumn_slice IS
		PORT(slice3_in, slice2_in, slice1_in, slice0_in : IN std_logic_vector (7 downto 0);
			slice3_out, slice2_out, slice1_out, slice0_out : OUT std_logic_vector (7 downto 0));
END MixColumn_slice;


ARCHITECTURE MixColumn_slice_logic OF MixColumn_slice IS

		SIGNAL sig0,sig1,sig2,sig3,sig4,sig5,sig6,sig7 : std_logic_vector (8 downto 0);
		SIGNAL sig8,sig9,sig10,sig11,sig12,sig13,sig14,sig15 : std_logic_vector (8 downto 0);

BEGIN
--------------------------------------------------------------------------------------
-------------------------> Implements Column 3 of MixColumn <-------------------------
--------------------------------------------------------------------------------------

		sig0 <= slice3_in & '0'; -- multiply by 02
		sig1 <= ('0' & slice2_in) XOR (slice2_in & '0'); --multiply by 03
		
		sig2 <= (sig0 XOR "100011011") when sig0(8)='1' else
				sig0;
				
		sig3 <= (sig1 XOR "100011011") when sig1(8) = '1' else
				sig1;

		slice3_out <= sig2(7 downto 0) XOR sig3(7 downto 0) XOR slice1_in XOR slice0_in;
		
--------------------------------------------------------------------------------------
-------------------------> Implements Column 2 of MixColumn <-------------------------
--------------------------------------------------------------------------------------

		sig4 <= slice2_in & '0'; -- multiply by 02
		sig5 <= ('0' & slice1_in) XOR (slice1_in & '0'); --multiply by 03

		sig6 <= (sig4 XOR "100011011") when sig4(8) = '1' else
				sig4;

		sig7 <= (sig5 XOR "100011011") when sig5(8) = '1' else
				sig5;

		slice2_out <= sig6(7 downto 0) XOR sig7(7 downto 0) XOR slice3_in XOR slice0_in;

--------------------------------------------------------------------------------------
-------------------------> Implements Column 1 of MixColumn <-------------------------
--------------------------------------------------------------------------------------

		sig8 <= slice1_in & '0'; -- multiply by 02
		sig9 <= ('0' & slice0_in) XOR (slice0_in & '0'); --multiply by 03

		sig10 <= (sig8 XOR "100011011") when sig8(8) = '1' else
				 sig8;

		sig11 <= (sig9 XOR "100011011") when sig9(8) = '1' else
				 sig9;

		slice1_out <= sig10(7 downto 0) XOR sig11(7 downto 0) XOR slice3_in XOR slice2_in;

--------------------------------------------------------------------------------------
-------------------------> Implements Column 0 of MixColumn <-------------------------
--------------------------------------------------------------------------------------

		sig12 <= slice0_in & '0'; -- multiply by 02
		sig13 <= ('0' & slice3_in) XOR (slice3_in & '0'); --multiply by 03

		sig14 <= (sig12 XOR "100011011") when sig12(8) = '1' else
				 sig12;

		sig15 <= (sig13 XOR "100011011") when sig13(8) = '1' else
				 sig13;

		slice0_out <= sig14(7 downto 0) XOR sig15(7 downto 0) XOR slice2_in XOR slice1_in;


END MixColumn_slice_logic;
