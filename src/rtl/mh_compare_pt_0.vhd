library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;
use work.MuctpiDataTypes.all;
use work.MuctpiFunctions.all;
use work.SortingHierarchical.all;

entity mh_compare_pt_0 is
  generic(num_in  : integer := CandidateNumber;  -- Number of candidates to be sorted
          num_out : integer := 16);     -- Number of sorted muons
  port(
    muon_cand    : in  MuonCandidateArray(0 to num_in - 1);
    pt_compare_0 : out pt_compare_matrix_t(0 to 0, 0 to num_in - 1)(0 to num_in - 2)
    );
end entity mh_compare_pt_0;

architecture RTL of mh_compare_pt_0 is
	
	signal pt_compare : pt_compare_matrix_t(0 to 0, 0 to num_in - 1)(0 to num_in - 2);
	
begin

  compare_p : process(all) is
  begin  -- process
    -- generate a comparison matrix
    for i in muon_cand'range loop
      for j in muon_cand'range loop
        -- generate the first half of the comparison matrix
        if j < i then
        -- comparison matrix for the top candidate
          pt_compare(0, i)(j) <= compare_pt(muon_cand(i).pt, muon_cand(j).pt);
        -- derive the 2nd half from the 1st
        end if;
      end loop;  -- j
    end loop;  -- i
end process compare_p;

pt_compare_0 <= pt_compare;

end architecture RTL;
