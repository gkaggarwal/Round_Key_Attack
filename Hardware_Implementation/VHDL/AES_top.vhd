-- written by Gaurav Aggarwal
-- Date : March 9th, 2020
-- Version : v.1.0


LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY top_aes IS
		PORT (clk, rst, data_rdy : IN std_logic;
			  plain_txt,enc_key :IN std_logic_vector(127 downto 0);
			  done : OUT std_logic;
			  cipher_out_reg :out std_logic_vector(127 downto 0));
END top_aes;


ARCHITECTURE top_aes_logic OF top_aes IS

		SIGNAL round_reg : std_logic_vector(127 downto 0);


-->>>>>>>>>>>>>>>>>>>>>>>>>---------------------------------------------------------<<<<<<<<<<<<<<<<<<

------------->>>>>>>>>> signal and component declaration for KeyExpansion instantiation--------->>>>>>

        SIGNAL  rnd_key, rnd_key1 : std_logic_vector(127 downto 0);
        
        COMPONENT KeyExpansion IS
        PORT (clk : IN std_logic;
			 Encry_load_round : IN std_logic_vector(3 downto 0);
			 encry_key_in : IN std_logic_vector(127 downto 0);
			 round_key : INOUT std_logic_vector(127 downto 0));
		END component;
		

-->>>>>>>>>>>>>>>>>>>>>>>>>---------------------------------------------------------<<<<<<<<<<<<<<<<<<


------------->>>>>>>>>> signal and component declaration for encry_round_controller instantiation--------->>>>>>

		
		SIGNAL encry_rnd : std_logic_vector(3 downto 0);
		SIGNAL enc_key_in :std_logic_vector(127 downto 0);
		COMPONENT encry_round_controller IS
				PORT (clk, rst, start : IN std_logic; 
					  cipher_text_ready : OUT std_logic; 
					  encry_round : OUT std_logic_vector (3 downto 0));
		END COMPONENT;
		
		
-->>>>>>>>>>>>>>>>>>>>>>>>>---------------------------------------------------------<<<<<<<<<<<<<<<<<<

------------->>>>>>>>>> signal and component declaration for PreRound instantiation--------->>>>>>
		
		
		SIGNAL pre_rnd_out : std_logic_vector(127 downto 0);
		
		COMPONENT pre_round IS
		PORT (plain_text : IN std_logic_vector(127 downto 0);
		      encry_key : IN std_logic_vector(127 downto 0);
		      pre_round_out : OUT std_logic_vector(127 downto 0));
		END COMPONENT;
		
		
		
-->>>>>>>>>>>>>>>>>>>>>>>>>---------------------------------------------------------<<<<<<<<<<<<<<<<<<

------------->>>>>>>>>> signal and component declaration for SBox instantiation--------->>>>>>

		
		SIGNAL sbx_in : std_logic_vector(127 downto 0);
		SIGNAL sbx_out : std_logic_vector(127 downto 0);
		
		COMPONENT SBox IS
				PORT (SBox_in : IN std_logic_vector(127 downto 0); 
					  SBox_out : OUT std_logic_vector(127 downto 0));
		END COMPONENT;
		
-->>>>>>>>>>>>>>>>>>>>>>>>>---------------------------------------------------------<<<<<<<<<<<<<<<<<<

------------->>>>>>>>>> signal and component declaration for shiftrows instantiation--------->>>>>>


		SIGNAL shftrows_out : std_logic_vector(127 downto 0);
		
		COMPONENT shiftrows IS
				PORT (shiftrows_in : IN std_logic_vector (127 downto 0); 
					  shiftrows_out : OUT std_logic_vector(127 downto 0));
		END COMPONENT;
		
		
-->>>>>>>>>>>>>>>>>>>>>>>>>---------------------------------------------------------<<<<<<<<<<<<<<<<<<

------------->>>>>>>>>> signal and component declaration for MixColumn instantiation--------->>>>>>

		
		SIGNAL mxcolumn_out : std_logic_vector(127 downto 0);
		
		COMPONENT MixColumn IS
				PORT (MixColumn_in : IN std_logic_vector (127 downto 0); 
					  MixColumn_out : OUT std_logic_vector (127 downto 0));
		END COMPONENT;
		
		
-->>>>>>>>>>>>>>>>>>>>>>>>>---------------------------------------------------------<<<<<<<<<<<<<<<<<<

------------->>>>>>>>>> signal and component declaration for RoundkeyAddition instantiation--------->>>>>>
		
		SIGNAL rnd_keyadd_out,r_key_in : std_logic_vector(127 downto 0);
		
		COMPONENT RoundkeyAddition IS
		PORT (RoundkeyAddition_in, RoundKey : IN std_logic_vector (127 downto 0);
			 RoundkeyAddition_out : OUT std_logic_vector (127 downto 0));
		END COMPONENT;
		
-->>>>>>>>>>>>>>>>>>>>>>>>>---------------------------------------------------------<<<<<<<<<<<<<<<<<<


BEGIN
		


		KE0 : KeyExpansion PORT MAP (clk,encry_rnd,enc_key_in,rnd_key1);
		ERC0 : encry_round_controller PORT MAP (clk=>clk,rst=>rst,start=>data_rdy,cipher_text_ready=>done,encry_round=>encry_rnd);
		PR0 : pre_round PORT MAP (plain_txt,enc_key,pre_rnd_out);
		SB0 : SBox PORT MAP (sbx_in, sbx_out);
		SR0 : shiftrows PORT MAP (sbx_out, shftrows_out);
		MC0 : MixColumn PORT MAP (shftrows_out,mxcolumn_out);
		RKA0 : RoundkeyAddition PORT MAP (r_key_in,rnd_key1,rnd_keyadd_out);
		
		
		
		PROCESS(clk,rst, rnd_keyadd_out)
		VARIABLE rnd_reg : std_logic_vector(127 downto 0);
		BEGIN
		      if rst='1' then
		          rnd_reg := (OTHERS=>'0');
		      elsif clk'event AND clk='1' then
		          rnd_reg := rnd_keyadd_out;
		      end if;
		      round_reg <= rnd_reg;		      
		 END PROCESS;
		
		process(clk, rnd_key1)
		begin
		if clk'event and clk='1' then
		  rnd_key<= rnd_key1;
		end if;
		end process;  
		
		
		PROCESS (encry_rnd,clk,mxcolumn_out)
		BEGIN
		          if encry_rnd="1010" then
		                  r_key_in <= shftrows_out;
		          else
		                  r_key_in <= mxcolumn_out;
		          end if;
		 END PROCESS;
		PROCESS (encry_rnd, pre_rnd_out, round_reg)
		BEGIN
		          if encry_rnd="0001" then
		                  sbx_in <= pre_rnd_out;
		          else
		                  sbx_in <= round_reg;
		          end if;
		 END PROCESS;
	
		
		PROCESS (encry_rnd, enc_key, rnd_key)
		BEGIN
		          if encry_rnd="0001" then
		                  enc_key_in <= enc_key;
		          else
		                  enc_key_in <= rnd_key;
		          end if;
		 END PROCESS;
		
		
		
		
	
		PROCESS(clk)
		BEGIN
		if encry_rnd="1010" then
    		if clk'event and clk='1' then
		         cipher_out_reg <= rnd_keyadd_out;
		    end if;      
		 end if;
		 END PROCESS;
		 
		END top_aes_logic;	






