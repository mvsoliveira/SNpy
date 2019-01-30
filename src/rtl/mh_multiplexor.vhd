library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;
use work.MuctpiDataTypes.all;
use work.MuctpiFunctions.all;
use work.SortingHierarchical.all;

entity mh_multiplexor is
	generic(num_in  : integer := CandidateNumber; -- Number of candidates to be sorted
	        num_out : integer := 16);   -- Number of sorted muons
	port(
		muon_cand     : in  MuonCandidateArray(0 to num_in - 1);
		max_pt        : in  std_logic_matrix(0 to num_out - 1)(0 to num_in - 1);
		top_cand_comb : out MuonCandidateArray(0 to num_out - 1)
	);
end entity mh_multiplexor;

architecture RTL of mh_multiplexor is

begin

	output_p : process(all)
		variable muon   : MuonCandidate;
		variable enable : std_logic;
	begin                               -- process
	--wait until rising_edge(clk);
	-- assign the highset pt candidate index to the corresponding output
		for k in top_cand_comb'range loop
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

end architecture RTL;
