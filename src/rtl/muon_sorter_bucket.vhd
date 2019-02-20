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

entity muon_sorter_bucket is

	generic(num_in  : natural;          -- candidates to be sorted
	        num_out : natural;          -- Number of sorted muons
	        delay   : natural);         -- delay in clock cycles for pipeline register

	port(clk          : in  std_logic;
	     sink_valid   : in  std_logic;
	     source_valid : out std_logic;
	     muon_cand    : in  MuonCandidateArray(0 to num_in - 1);
	     top_cand     : out MuonCandidateArray(0 to num_out - 1));

end muon_sorter_bucket;

-------------------------------------------------------------------------------

architecture behavior of muon_sorter_bucket is

	signal top_cand_comb : MuonCandidateArray(0 to num_out - 1);

	-- pipeline

	type sr_t is array (integer range <>) of MuonCandidateArray(0 to num_out - 1);
	signal sr   : sr_t(0 to delay);
	signal sr_v : std_logic_vector(0 to delay);

	attribute shreg_extract : string;
	attribute shreg_extract of sr : signal is "no";
	attribute shreg_extract of sr_v : signal is "no";

	attribute syn_srlstyle : string;
	attribute syn_srlstyle of sr : signal is "registers";
	attribute syn_srlstyle of sr_v : signal is "registers";

	constant pt_w : integer := CandidatePtValue'left + 1;

begin

	sorting : process(all) is
		variable o : integer range 0 to num_out;
	begin                               -- process
		o := 0;
		for t in 2**pt_w - 1 downto 0 loop
			for i in muon_cand'reverse_range loop
				if o < num_out then
					if muon_cand(i).pt = t then
						top_cand_comb(o) <= muon_cand(i);
						o                := o + 1;
					end if;
				end if;
			end loop;
		end loop;
	end process sorting;

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
