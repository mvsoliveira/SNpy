library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;
use work.MuctpiDataTypes.all;
use work.MuctpiFunctions.all;
use work.SortingHierarchical.all;

entity mh_compare_pt_and_find_max_pt_hierarchical is
	generic(num_in  : integer := CandidateNumber; -- Number of candidates to be sorted
	        num_out : integer := 16);   -- Number of sorted muons
	port(
		muon_cand : in  MuonCandidateArray(0 to num_in - 1);
		-- array with flags for the highest candidate
		max_pt    : out std_logic_matrix(0 to num_out - 1)(0 to num_in - 1)
	);
end entity mh_compare_pt_and_find_max_pt_hierarchical;

architecture RTL of mh_compare_pt_and_find_max_pt_hierarchical is

	-- array of compare matrices, one per output candidate

signal pt_compare_0 : pt_compare_matrix_t(0 to 0, 0 to num_in - 1)(0 to num_in - 2);

begin

	mh_compare_pt_0_1: entity work.mh_compare_pt_0
  generic map (
    num_in  => num_in,
    num_out => num_out)
  port map (
    muon_cand    => muon_cand,
    pt_compare_0 => pt_compare_0);
    
    mh_compare_pt_1_and_find_max_1: entity work.mh_compare_pt_1_and_find_max
  generic map (
    num_in  => num_in,
    num_out => num_out)
  port map (
    pt_compare_0 => pt_compare_0,
    max_pt       => max_pt);
    
    
    
end architecture RTL;
