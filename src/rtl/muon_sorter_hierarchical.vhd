-------------------------------------------------------------------------------
-- Title      : Muon canidate sorter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : muon_sorter.vhd
-- Author     : Stefan Haas
-- Company    : CERN PH-ATE
-- Created    : 12-07-13
-- Last update: 2019-01-30
-- Platform   : Windows XP
-- Standard   : VHDL-2008
-------------------------------------------------------------------------------
-- Description: Sorts muon candiates by pT 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 CERN PH-ATE
-------------------------------------------------------------------------------
-- Revisions  :
-- Date      Version  Author  Description
-- 12-07-13  1.0      haass   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;
use work.MuctpiDataTypes.all;
use work.MuctpiFunctions.all;
use work.SortingHierarchical.all;

entity muon_sorter_hierarchical is

	generic(num_in  : integer  := CandidateNumber; -- Number of candidates to be sorted
	        num_out : integer  := 16;   -- Number of sorted muons
	        delay   : positive := 1;    -- delay in clock cycles for pipeline register
	        int_reg : boolean  := False);

	port(clk          : in  std_logic;
	     sink_valid   : in  std_logic;
	     source_valid : out std_logic;
	     muon_cand    : in  MuonCandidateArray(0 to num_in - 1);
	     top_cand     : out MuonCandidateArray(0 to num_out - 1));

end muon_sorter_hierarchical;

-------------------------------------------------------------------------------

architecture behavior of muon_sorter_hierarchical is

	-- array with flags for the highest candidate
	signal max_pt : std_logic_matrix(0 to num_out - 1)(0 to num_in - 1);

	signal top_cand_comb : MuonCandidateArray(0 to num_out - 1);

	-- pipeline
	type sr_t is array (integer range <>) of MuonCandidateArray(0 to num_out - 1);
	type muon_cand_int_reg_t is array (integer range <>) of MuonCandidateArray(0 to num_in - 1);
	signal sr                 : sr_t(0 to delay);
	signal sr_v               : std_logic_vector(0 to delay);
	signal sink_valid_int_reg : std_logic_vector(0 to 2);
	signal sink_valid_int     : std_logic;
	signal muon_cand_int_reg  : muon_cand_int_reg_t(0 to 2);
	signal muon_cand_int      : MuonCandidateArray(0 to num_in - 1);

	attribute shreg_extract : string;
	attribute shreg_extract of sr : signal is "no";
	attribute shreg_extract of sr_v : signal is "no";

begin

	-- compare pt
	mh_compare_pt_and_find_max_pt_hierarchical_0 : entity work.mh_compare_pt_and_find_max_pt_hierarchical
		generic map(
			num_in  => num_in,
			num_out => num_out,
			int_reg => int_reg)
		port map(
			clk       => clk,
			muon_cand => muon_cand,
			max_pt    => max_pt);

	-- multiplexor	

	mh_multiplexor_1 : entity work.mh_multiplexor
		generic map(
			num_in  => num_in,
			num_out => num_out)
		port map(
			muon_cand     => muon_cand_int,
			max_pt        => max_pt,
			top_cand_comb => top_cand_comb);

	int_reg_g : if int_reg generate
	begin
		process(all) is
		begin
			sink_valid_int_reg(0) <= sink_valid;
			muon_cand_int_reg(0)  <= muon_cand;
			if rising_edge(clk) then
				for i in 1 to 2 loop
					sink_valid_int_reg(i) <= sink_valid_int_reg(i - 1);
					muon_cand_int_reg(i)  <= muon_cand_int_reg(i - 1);
				end loop;
			end if;
		end process;
		sink_valid_int <= sink_valid_int_reg(2);
		muon_cand_int  <= muon_cand_int_reg(2);
	end generate;

	not_int_reg_g : if not int_reg generate
	begin
		sink_valid_int <= sink_valid;
		muon_cand_int  <= muon_cand;
	end generate;

	sr_p : process(all) is
	begin
		sr(0)   <= top_cand_comb;
		sr_v(0) <= sink_valid_int;
		if rising_edge(clk) then
			for i in 1 to delay loop
				sr(i)   <= sr(i - 1);
				sr_v(i) <= sr_v(i - 1);
			end loop;
		end if;
	end process sr_p;

	top_cand     <= sr(delay);
	source_valid <= sr_v(delay);

end behavior;
