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

entity muon_sorter is

	generic(num_in  : natural;   -- candidates to be sorted
	        num_out : natural;   -- Number of sorted muons
	        delay   : natural);   -- delay in clock cycles for pipeline register

	port(clk          : in  std_logic;
	     sink_valid   : in  std_logic;
	     source_valid : out std_logic;
	     muon_cand    : in  MuonCandidateArray(0 to num_in - 1);
	     top_cand     : out MuonCandidateArray(0 to num_out - 1));

end muon_sorter;

-------------------------------------------------------------------------------

architecture behavior of muon_sorter is

	-- 2D matrix of std_logic
	type std_logic_matrix is array (natural range <>) of std_logic_vector;
	-- array of comparison matrices, one per output candidate
	type pt_compare_matrix_t is array (integer range <>) of std_logic_matrix(0 to num_in - 1)(0 to num_in - 2);

	-- not accepted by Synplify
	--  constant all_greater : pt_compare_matrix_t'element'element := (others => '1');
	constant all_greater : std_logic_vector(0 to num_in - 2) := (others => '1');

	-- array of compare matrices, one per output candidate
	signal pt_compare : pt_compare_matrix_t(top_cand'range);
	-- array with flags for the highest candidate
	signal max_pt     : std_logic_matrix(0 to num_out - 1)(0 to num_in - 1);

	signal top_cand_comb : MuonCandidateArray(0 to num_out - 1);
	

	-- pipeline
	
	
	type sr_t is array (integer range <>) of MuonCandidateArray(0 to num_out - 1);
	signal sr : sr_t(0 to delay);
	signal sr_v : std_logic_vector(0 to delay);

	attribute shreg_extract : string;
	attribute shreg_extract of sr : signal is "no";
	attribute shreg_extract of sr_v : signal is "no";
	
	attribute syn_srlstyle: string;  
    attribute syn_srlstyle of sr : signal is "registers";
    attribute syn_srlstyle of sr_v : signal is "registers";

begin

	compare_p : process(all) is
	begin                               -- process
	-- generate a comparison matrix
		for i in muon_cand'range loop
			for j in muon_cand'range loop
				-- generate the first half of the comparison matrix
				if j < i then
					-- comparison matrix for the top candidate
					pt_compare(0)(i)(j) <= compare_pt(muon_cand(i).pt, muon_cand(j).pt);
					-- derive the matrices for the next higher candidates
					for k in 1 to num_out - 1 loop
						-- invert the comparison result if either candidate is the highest one
						pt_compare(k)(i)(j) <= pt_compare(k - 1)(i)(j) xor max_pt(k - 1)(i) xor max_pt(k - 1)(j);
					end loop;           -- k
					-- derive the 2nd half from the 1st
				elsif j > i then
					for k in pt_compare'range loop
						pt_compare(k)(i)(j - 1) <= not pt_compare(k)(j)(i);
					end loop;           -- k
				end if;
			end loop;                   -- j
			-- find the top candidate, i.e. the one for which all comparisons are true
			for k in max_pt'range loop
				max_pt(k)(i) <= pt_compare(k)(i) ?= all_greater;
			end loop;                   -- k
		end loop;                       -- i
	end process compare_p;

	output_p : process(all)
		variable muon   : MuonCandidate;
		variable enable : std_logic;
	begin                               -- process
	--wait until rising_edge(clk);
	-- assign the highset pt candidate index to the corresponding output
		for k in top_cand'range loop
			muon             := (sector => X"0", pt => X"0", roi => X"00");
			for i in muon_cand'range loop
				-- there can only be one highest pt candidate, so ne can use a logical OR to implement a multiplexer
				--        enable := pt_compare(k)(i) ?= all_greater;
				enable      := max_pt(k)(i);
				muon.pt     := muon.pt or (enable and muon_cand(i).pt);
				muon.sector := muon.sector or (enable and muon_cand(i).sector);
				muon.roi    := muon.roi or (enable and muon_cand(i).roi);
			end loop;
			top_cand_comb(k) <= muon;
		end loop;                       -- k
	end process output_p;


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