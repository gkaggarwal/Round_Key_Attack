-- Written by Gaurav Aggarwal
-- Date: 13th March, 2020
-- Version: v.1.0

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY encry_round_controller IS
		PORT (clk, rst, start : IN std_logic;
		cipher_text_ready : OUT std_logic;
		encry_round : OUT std_logic_vector(3 downto 0));
END encry_round_controller;

ARCHITECTURE encry_round_controller_design OF encry_round_controller IS
		TYPE round_state IS (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15);
		SIGNAL state : round_state;
BEGIN
		PROCESS (clk, rst)
		BEGIN
				if (rst='1') then
						state <= S0; 
				elsif (clk'event AND clk='1') then
						CASE state IS
								when S0 =>
										if start = '1' then
											state <= S1;
									else
											state <= S0;
									end if;
								when S1 =>
										state <= S2;
								when S2 =>
										state <= S3;
								when S3 =>
										state <= S4;
								when S4 =>
										state <= S5;
								when S5 =>
										state <= S6;
								when S6 =>
										state <= S7;
								when S7 =>
										state <= S8;
								when S8 =>
										state <= S9;
								when S9 =>
										state <= S10;
								when S10 =>
										if start = '1' then
											state <= S1;
									else
											state <= S10;
									end if;
								when OTHERS =>
											state <= S0;
						end CASE;
				end if;
		END PROCESS;

		PROCESS (state)
		BEGIN
				CASE state is
						when S0 =>
								encry_round <= "0000";
								cipher_text_ready <= '0';
						when S1 =>
								encry_round <= "0001";
								cipher_text_ready <= '0';
						when S2 =>
								encry_round <= "0010";
								cipher_text_ready <= '0';
						when S3 =>
								encry_round <= "0011";
								cipher_text_ready <= '0';
						when S4 =>
								encry_round <= "0100";
								cipher_text_ready <= '0';
						when S5 =>
								encry_round <= "0101";
								cipher_text_ready <= '0';
						when S6 =>
								encry_round <= "0110";
								cipher_text_ready <= '0';
						when S7 =>
								encry_round <= "0111";
								cipher_text_ready <= '0';
						when S8 =>
								encry_round <= "1000";
								cipher_text_ready <= '0';
						when S9 =>
								encry_round <= "1001";
								cipher_text_ready <= '0';
						when S10 =>
								encry_round <= "1010";
								cipher_text_ready <= '1';
						when OTHERS =>
								encry_round <= "0000";
								cipher_text_ready <= '0';
				END CASE;
		END PROCESS;
END encry_round_controller_design;

