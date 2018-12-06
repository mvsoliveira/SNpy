-------------------------------------------------------------------------------
-- Title      : MUCTPI utility functions
-- Project    : MUCTPI-L1Topo interface
-------------------------------------------------------------------------------
-- File       : MuctpiFunctions.vhd
-- Author     : Stefan Haas
-- Company    : CERN PH-ATE
-- Created    : 12-07-13
-- Last update: 2018-12-06
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

  -- to_muon overloaded function
  function to_muon (data : std_logic_vector; N : integer) return MuonCandidateArray;
    function to_stdv (muon_a : MuonCandidateArray; N : integer) return std_logic_vector;

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
    return pt_a ?>= pt_b;  -- this operator works only with ieee.numeric_std_unsigned package, this operator can be changed in the future in order to avoid to use different numeric packages than ieee.numeric_std
--    return ((pt_valid(pt_a) and (pt_a ?>= pt_b)) or not pt_valid(pt_b));
  end compare_pt;

  function to_muon (data : std_logic_vector; N : integer) return MuonCandidateArray is
    variable muon_a : MuonCandidateArray(0 to N-1);
    variable data_i : integer := 0;
    variable l      : integer;
  begin
    for mc in muon_a'range loop
      l                 := muon_a(mc).sector'length;
      muon_a(mc).sector := data(data_i+l-1 downto data_i);
      data_i            := data_i + l;

      l             := muon_a(mc).pt'length;
      muon_a(mc).pt := data(data_i+l-1 downto data_i);
      data_i        := data_i + l;

      l              := muon_a(mc).roi'length;
      muon_a(mc).roi := data(data_i+l-1 downto data_i);
      data_i         := data_i + l;
    end loop;
    return muon_a;
  end to_muon;

  function to_stdv (muon_a : MuonCandidateArray; N : integer) return std_logic_vector is
    variable data : std_logic_vector(N*MuonCandidateLength-1 downto 0);
    variable data_i : integer := 0;
    variable l      : integer;
  begin
    for mc in muon_a'range loop
      l                 := muon_a(mc).sector'length;
      data(data_i+l-1 downto data_i) := muon_a(mc).sector;
      data_i            := data_i + l;

      l             := muon_a(mc).pt'length;
      data(data_i+l-1 downto data_i) := muon_a(mc).pt;
      data_i        := data_i + l;

      l              := muon_a(mc).roi'length;
      data(data_i+l-1 downto data_i) := muon_a(mc).roi;
      data_i         := data_i + l;
    end loop;
    return data;
  end to_stdv;
  
end package body MuctpiFunctions;
