----------------------------------------------------------------------------------------------------------------------
-- Title      : wrapper_csn_sel
-- Project    : MUCTPI

----------------------------------------------------------------------------------------------------------------------
-- File       : wrapper_csn_sel.vhd
-- Author     : Marcos Oliveira
-- Company    : CERN
-- Created    : 2018-12-05
-- Last update: 2018-12-12
-- Platform   : Vivado 2017.2 and Mentor Modelsim SE-64 10.4a
-- Standard   : VHDL'93/02
----------------------------------------------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 CERN
----------------------------------------------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-12-05  1.0      msilvaol        Created
----------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.math_real.all;

use work.csn_pkg.all;

entity wrapper_csn_sel is

	generic(
		I     : natural := 352;
		O     : natural := 16;
		delay : natural := 3            -- delay in clock cycles for pipeline register
	);

	port(
		clk_wrapper : in  std_logic; 
		clk         : in  std_logic;
		input       : in  std_logic;
		output      : out std_logic);
	attribute syn_loc      : string;
	attribute syn_pad_type : string;
	attribute syn_loc of clk_wrapper : signal is "AU33";
	attribute syn_loc of clk : signal is "AV33";
	attribute syn_loc of input : signal is "AN32";
	attribute syn_loc of output : signal is "AU31";
	attribute syn_pad_type of clk_wrapper : signal is "LVCMOS18";
	attribute syn_pad_type of clk : signal is "LVCMOS18";
	attribute syn_pad_type of input : signal is "LVCMOS18";
	attribute syn_pad_type of output : signal is "LVCMOS18";

end entity wrapper_csn_sel;

architecture rtl of wrapper_csn_sel is

	--constants
	constant i_width         : integer := I * PT_WIDTH + 1;
	constant o_width_desired : integer := O * out_word_w;
	constant log4_o_width    : integer := integer(ceil(log(real(o_width_desired), real(4))));
	constant o_width         : integer := 4**log4_o_width;

	--components

	component lfsr is
		generic(
			WIDTH : natural);
		port(
			clock         : in  std_logic;
			input_bit     : in  std_logic;
			output_vector : out std_logic_vector(WIDTH - 1 downto 0));
	end component lfsr;

	component reducer is
		generic(
			input_width_log4 : natural);
		port(
			clock        : in  std_logic;
			input_vector : in  std_logic_vector(4**input_width_log4 - 1 downto 0);
			output_bit   : out std_logic);
	end component reducer;


	signal input_vector  : std_logic_vector(i_width - 1 downto 0);
	signal input_slr     : std_logic_vector(i_width - 1 downto 0);
	signal output_vector : std_logic_vector(o_width - 1 downto 0);
	signal output_slr    : std_logic_vector(o_width - 1 downto 0);

	signal muon_cand    : muon_sel_a(0 to I - 1);
	signal top_cand     : muon_a(0 to O - 1);


	attribute DONT_TOUCH : string;
	attribute DONT_TOUCH of lsfr_1 : label is "TRUE";
	attribute DONT_TOUCH of reducer_1 : label is "TRUE";


begin                                   -- architecture rtl

	lsfr_1 : lfsr
		generic map(
			WIDTH => i_width)
		port map(
			clock         => clk_wrapper,
			input_bit     => input,
			output_vector => input_vector);

	shift_reg_tap_i : entity work.shift_reg_tap
		generic map(
			dw => i_width,
			tw => 1)
		port map(
			clk    => clk,
			ce     => '1',
			tap    => (others => '1'),
			input  => input_vector,
			output => input_slr);

	shift_reg_tap_o : entity work.shift_reg_tap
		generic map(
			dw => o_width,
			tw => 1)
		port map(
			clk    => clk,
			ce     => '1',
			tap    => (others => '1'),
			input  => output_vector,
			output => output_slr);

	reducer_1 : reducer
		generic map(
			input_width_log4 => log4_o_width)
		port map(
			clock        => clk_wrapper,
			input_vector => output_slr,
			output_bit   => output);

	----------------------------------------------------------------------------------------------------------------------
	-- Logic being tested
	----------------------------------------------------------------------------------------------------------------------

	muon_cand                                    <= to_sel_array(input_slr, I);
	output_vector(O * word_w - 1 downto 0)       <= to_stdv(top_cand, O);
	output_vector(o_width - 1 downto O * word_w) <= (others => '0');

	dut_inst : entity work.csn_sel_wrapper
		generic map(
			I     => I,
			O     => O,
			delay => delay
		)
		port map(
			clk    => clk,
		    sink_valid   => input_slr(i_width - 1),
            --source_valid => output_vector(o_width - 1),
            source_valid => open,
			muon_i => muon_cand,
			muon_o => top_cand
		);
		
	

end architecture rtl;