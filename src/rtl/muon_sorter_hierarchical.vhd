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
	        delay   : positive := 1);   -- delay in clock cycles for pipeline register

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
	signal sr   : sr_t(0 to delay);
	signal sr_v : std_logic_vector(0 to delay);

	attribute shreg_extract : string;
	attribute shreg_extract of sr : signal is "no";
	attribute shreg_extract of sr_v : signal is "no";

begin

	-- compare pt
	mh_compare_pt_and_find_max_pt : entity work.mh_compare_pt_and_find_max_pt
		generic map(
			num_in  => num_in,
			num_out => num_out)
		port map(
			muon_cand => muon_cand,
			max_pt    => max_pt);

	-- multiplexor	

	mh_multiplexor_1 : entity work.mh_multiplexor
		generic map(
			num_in  => num_in,
			num_out => num_out)
		port map(
			muon_cand     => muon_cand,
			max_pt        => max_pt,
			top_cand_comb => top_cand_comb);

	sr_p : process(all) is
	begin
		sr(0)   <= top_cand_comb;
		sr_v(0) <= sink_valid;
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
