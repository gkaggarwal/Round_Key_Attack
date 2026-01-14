-- Written by Gaurav Aggarwal
-- Date: 20th March, 2020
-- Version: v.1.0


LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY KeyExpansion IS
		PORT(clk : IN std_logic;
			 Encry_load_round : IN std_logic_vector(3 downto 0);
			 encry_key_in : IN std_logic_vector(127 downto 0);
			 round_key : INOUT std_logic_vector(127 downto 0));
END KeyExpansion;


ARCHITECTURE KeyExpansion_logic OF KeyExpansion IS

			SIGNAL sig0 : std_logic_vector(31 downto 0);
			SIGNAL encry_key: std_logic_vector(31 downto 0);
            SIGNAL r_key :  std_logic_vector(127 downto 0);
		COMPONENT KeyExpansion_slice IS
				PORT(Encry_load_round : IN std_logic_vector (3 downto 0);
					 slice_in : IN std_logic_vector(31 downto 0);
					 slice_out : OUT std_logic_vector(31 downto 0));
		END COMPONENT;
BEGIN
		KE1 : KeyExpansion_slice PORT MAP (Encry_load_round,encry_key_in(31 downto 0),sig0);
		
		 
		PROCESS(clk,sig0)
				VARIABLE temp3,temp2,temp1,temp0 : std_logic_vector(31 downto 0);
		BEGIN
		          
						--CASE Encry_load_round IS
						--		WHEN "0001" =>
										temp3 := encry_key_in(127 downto 96) XOR sig0;
										temp2 := encry_key_in(95 downto 64) XOR temp3;
										temp1 := encry_key_in(63 downto 32) XOR temp2;
										temp0 := encry_key_in(31 downto 0) XOR temp1;
										
							--	WHEN OTHERS =>
							--			temp3 := round_key(127 downto 96) XOR sig0;
								--		temp2 := round_key(95 downto 64) XOR temp3;
--										temp1 := round_key(63 downto 32) XOR temp2;
								--		temp0 := round_key(31 downto 0) XOR temp1;
										
						--END CASE;
				round_key(127 downto 96) <= temp3;
				round_key(95 downto 64) <= temp2;
				round_key(63 downto 32) <= temp1;
				round_key(31 downto 0) <= temp0;
			
		END PROCESS;
		
		
	
END KeyExpansion_logic;

