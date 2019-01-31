library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;
use work.MuctpiDataTypes.all;
use work.MuctpiFunctions.all;
use work.SortingHierarchical.all;

entity mh_compare_pt_1_and_find_max is
  generic(num_in  : integer := CandidateNumber;  -- Number of candidates to be sorted
          num_out : integer := 16);     -- Number of sorted muons
  port(
    pt_compare_0 : in  pt_compare_matrix_t(0 to 0, 0 to num_in - 1)(0 to num_in - 2);
    max_pt       : out std_logic_matrix(0 to num_out - 1)(0 to num_in - 1)
    );
end entity mh_compare_pt_1_and_find_max;

architecture RTL of mh_compare_pt_1_and_find_max is

  signal pt_compare    : pt_compare_matrix_t(0 to num_out - 1, 0 to num_in - 1)(0 to num_in - 2);
  constant all_greater : std_logic_vector(0 to num_in - 2) := (others => '1');

begin
  
  compare_p : process(all) is
  begin  -- process
    -- generate a comparison matrix
    for i in 0 to num_in - 1 loop
      for j in 0 to num_in - 1 loop
        -- generate the first half of the comparison matrix
        if j < i then
                                        -- comparison matrix for the top candidate
          pt_compare(0, i)(j) <= pt_compare_0(0, i)(j);
                                        -- derive the matrices for the next higher candidates
          for k in 1 to num_out - 1 loop
                                        -- invert the comparison result if either candidate is the highest one
            pt_compare(k, i)(j) <= pt_compare(k - 1, i)(j) xor max_pt(k - 1)(i) xor max_pt(k - 1)(j);
          end loop;  -- k
                                      -- derive the 2nd half from the 1st
        elsif j > i then
          for k in 0 to num_out - 1 loop
            pt_compare(k, i)(j - 1) <= not pt_compare(k, j)(i);
          end loop;  -- k
        end if;
      end loop;  -- j
      -- find the top candidate, i.e. the one for which all comparisons are true
      for k in max_pt'range loop
        max_pt(k)(i) <= pt_compare(k, i) ?= all_greater;
      end loop;  -- k
    end loop;  -- i
  end process compare_p;

end architecture RTL;
