library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity SequenceRecognizer_tb is
	end SequenceRecognizer_tb;
	
architecture beh of SequenceRecognizer_tb is
	
	constant clk_period	: time	:= 100 ns;
	constant N	:positive	:= 8;
	
	component SequenceRecognizer
	generic (
			N : positive:= 8
		);
	port (
		num_in: in std_logic_vector(N-1 downto 0);
		reset: in std_logic;
		warning_out: out std_logic;
		unlock_out: out std_logic;
		clk: in std_logic;
		first_in: in std_logic
		);
	end component;
	
	signal num_in_ext	: std_logic_vector(N-1 downto 0) :=(others => '0');
	signal warning_ext	: std_logic:= '0';
	signal unlock_ext	: std_logic:= '0';
	signal first_ext	: std_logic:= '0';
	signal reset_ext	:std_logic:='0';
	signal clk_ext	: std_logic:='0';
	signal testing	: boolean := true;
	
	begin
		clk_ext <= not clk_ext after clk_period/2 when testing else '0';
		
		dut: SequenceRecognizer
		generic map (
			N => N
			)
		port map(
			num_in => num_in_ext,
			warning_out => warning_ext,
			unlock_out => unlock_ext,
			first_in => first_ext,
			reset => reset_ext,
			clk => clk_ext
			);
			
		stimulus : process
			begin
				
				reset_ext <= '1';
				wait until rising_edge(clk_ext);
				reset_ext <= '0';
				wait until rising_edge(clk_ext);
				num_in_ext <= "00100100";
				first_ext <= '1';
				wait until rising_edge(clk_ext);
				num_in_ext <= "00010011";
				first_ext <= '0';
				wait until rising_edge(clk_ext);
				num_in_ext <= "00111000";
				first_ext <= '0';
				wait until rising_edge(clk_ext);
				num_in_ext <= "01100101";
				first_ext <= '0';
				wait until rising_edge(clk_ext);
				num_in_ext <= "01001001";
				first_ext <= '0';
				wait until rising_edge(clk_ext);
				num_in_ext <= "00111000";
				first_ext <= '0';
				wait until rising_edge(clk_ext);
				num_in_ext <= "00111000";
				first_ext <= '0';
				wait until rising_edge(clk_ext);
				num_in_ext <= "00111000";
				first_ext <= '0';
				wait until rising_edge(clk_ext);
				num_in_ext <= "00111000";
				first_ext <= '0';
				wait until rising_edge(clk_ext);
				num_in_ext <= "00111000";
				first_ext <= '0';
				wait until rising_edge(clk_ext);
				num_in_ext <= "00111000";
				first_ext <= '0';
				wait until rising_edge(clk_ext);
				num_in_ext <= "00111000";
				first_ext <= '0';
				wait until rising_edge(clk_ext);
				num_in_ext <= "00111000";
				first_ext <= '0';
				wait until rising_edge(clk_ext);
				num_in_ext <= "00111000";
				first_ext <= '0';
				wait until rising_edge(clk_ext);
				num_in_ext <= "00111000";
				first_ext <= '0';
				wait until rising_edge(clk_ext);
				num_in_ext <= "00111000";
				first_ext <= '0';
				wait for 1200 ns;
				testing <= false;
		end process;
	end beh;				