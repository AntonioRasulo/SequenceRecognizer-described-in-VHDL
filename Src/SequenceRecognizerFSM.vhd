--Sequence Recognizer
library STD;
use STD.standard.all;
use STD.textio.all;

library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.NUMERIC_STD.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity SequenceRecognizer is 

	generic (
			N : positive:= 8
	);
	port(
		num_in: in std_logic_vector(N-1 downto 0);
		reset: in std_logic;
		warning_out: out std_logic;
		unlock_out: out std_logic;
		clk: in std_logic;
		first_in: in std_logic
	);

end entity;

architecture Moore of SequenceRecognizer is

	type STATUS is (START, FIRST, SECOND, THIRD, FOURTH, UNLOCK, LOCK, FAIL, WARNING);
	signal counter: std_logic_vector(2 downto 0); 		--Counter, to check the number of clock cycle
	
	signal PRESENT_STATUS: STATUS := START; --initial state is START
	signal NEXT_STATUS: STATUS := START;	--initial state is START
	
	signal Y_unlock: std_logic;
	signal Y_warning: std_logic;
	
begin

--Next state and output
delta_lambda: process (PRESENT_STATUS, num_in, first_in)
begin

	case PRESENT_STATUS is
		
		when START =>
			counter <= "000";
			if(first_in /= '0' and num_in = "00100100") then	--if num_in == 36 and is the first number
				NEXT_STATUS <= FIRST;
			else
				NEXT_STATUS <= START;
			end if;
		
		when FIRST =>
			counter <= "001";
			if(first_in /= '0') then
				NEXT_STATUS <= WARNING;
			elsif (num_in = "000010011") then	--if num_in == 19
				NEXT_STATUS <= SECOND;
			else
				NEXT_STATUS <= FAIL;
			end if;
		
		when SECOND =>
			counter <= "010";
			if(first_in /= '0') then
				NEXT_STATUS <= WARNING;
			elsif (num_in = "00111000") then	--if num_in == 56
				NEXT_STATUS <= THIRD;
			else
				NEXT_STATUS <= FAIL;
			end if;
		
		when THIRD =>
			counter <= "011";
			if(first_in /= '0') then
				NEXT_STATUS <= WARNING;
			elsif (num_in = "01100101") then	--if num_in == 101
				NEXT_STATUS <= FOURTH;
			else
				NEXT_STATUS <= FAIL;
			end if;
			
		when FOURTH =>
			counter <= "100";
			if(first_in /= '0') then
				NEXT_STATUS <= WARNING;
			elsif (num_in = "01001001") then	--if num_in == 73
				NEXT_STATUS <= UNLOCK;
			else
				NEXT_STATUS <= FAIL;
			end if;
			
		when FAIL =>
			counter <= counter + "001";
			if(counter = "101") then
				NEXT_STATUS <= LOCK;
			else
				NEXT_STATUS <= FAIL;
			end if;
			
		when LOCK =>
			NEXT_STATUS <= START;
			
		when UNLOCK =>
			NEXT_STATUS <= START;
			
		when WARNING =>
			NEXT_STATUS <= WARNING;
			
		when others =>
			NEXT_STATUS <= START;	--error
	end case;

end process;

--Output
lambda: process(PRESENT_STATUS)
begin
	case PRESENT_STATUS is
		when WARNING|LOCK =>
			Y_unlock <= '0';
			Y_warning <= '1';
		when UNLOCK =>
			Y_unlock <= '1';
			Y_warning <= '0';
		when others =>
			Y_unlock <= '0';
			Y_warning <= '0';
	end case;
end process;

--State register
state: process(clk)
begin
	if(clk'event and clk = '1') then 
		if(reset = '1') then
			PRESENT_STATUS <= START;
		else
			PRESENT_STATUS <= NEXT_STATUS;
		end if;
	end if;
end process;

--Output register
output: process(clk)
begin
	if(clk'event and clk = '1') then
		if(reset = '1') then
			unlock_out <= '0';
			warning_out <= '0';
		else
			unlock_out <= Y_unlock;
			warning_out <= Y_warning;
		end if;
	end if;	
end process;


end Moore;