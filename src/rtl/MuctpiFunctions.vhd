-------------------------------------------------------------------------------
-- Title      : MUCTPI utility functions
-- Project    : MUCTPI-L1Topo interface
-------------------------------------------------------------------------------
-- File       : MuctpiFunctions.vhd
-- Author     : Stefan Haas
-- Company    : CERN PH-ATE
-- Created    : 12-07-13
-- Last update: 2013-08-12
-- Platform   : Windows XP
-- Standard   : VHDL-2008
-------------------------------------------------------------------------------
-- Description: 
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

package MuctpiFunctions is

  -- Check if there is valid candidate, i.e. pT != 0 && pT != 7
  function pt_valid (pt : CandidatePtValue) return std_logic;

  -- Compare two pT values, returns '1' if pt_a greater than or equal to pt_b
  function compare_pt (pt_a, pt_b : CandidatePtValue) return std_logic;

end package MuctpiFunctions;

-------------------------------------------------------------------------------

package body MuctpiFunctions is

  -----------------------------------------------------------------------------
  -- Check if there is valid candidate, i.e. pT != 0 && pT != 7
  -----------------------------------------------------------------------------
  function pt_valid (pt : CandidatePtValue) return std_logic is
  begin  -- pt_valid
    return not(pt ?= O"0");
  end pt_valid;

  -----------------------------------------------------------------------------
  -- Compare two pT values, returns '1' if pt_a greater than or equal to pt_b
  -----------------------------------------------------------------------------
  function compare_pt (pt_a, pt_b : CandidatePtValue) return std_logic is
  begin  -- compare_pt
    return pt_a ?>=  pt_b; -- this operator works only with ieee.numeric_std_unsigned package, this operator can be changed in the future in order to avoid to use different numeric packages than ieee.numeric_std
--    return ((pt_valid(pt_a) and (pt_a ?>= pt_b)) or not pt_valid(pt_b));
  end compare_pt;
  
end package body MuctpiFunctions;
