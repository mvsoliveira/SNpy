-------------------------------------------------------------------------------
-- Title      : Candidate veto application
-- Project    : MUCTPI-L1Topo interface
-------------------------------------------------------------------------------
-- File       : candidate_veto.vhd
-- Author     :   <msilvaol@PCPHL1CT04>
-- Company    : CERN
-- Created    : 2013-07-16
-- Last update: 2013-11-05
-- Platform   : Symplify Premier G-2012.09 and Modelsim SE-64 10.1c
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 CERN
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-07-16  1.0      msilvaol        Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.MuctpiDataTypes.all;

entity candidate_veto is
  
  generic (
    CandidateNumber : integer := CandidateNumber);

  port (
    clk           : in  std_logic;
    rst           : in  std_logic;
    sink_valid    : in  std_logic;
    source_valid  : out std_logic;
    veto_mul      : in  std_logic_vector(CandidateNumber-1 downto 0); -- veto for each multiplicity
    muon_cand_in  : in  MuonCandidateArray(0 to CandidateNumber-1);  -- Muon candidates in the input
    muon_cand_out : out MuonCandidateArray(0 to CandidateNumber-1));  -- Muon candidates after applying veto

end entity candidate_veto;

architecture behavior of candidate_veto is

  signal muon_cand_comb : MuonCandidateArray(0 to CandidateNumber-1);

begin  -- architecture behavior

  veto : process (veto_mul, muon_cand_in) is
  begin
    for i in muon_cand_in'range loop
      if (veto_mul(i) or muon_cand_in(i).pt ?= x"F") then
        muon_cand_comb(i).pt <= (others => '0');
      else
        muon_cand_comb(i).pt <= muon_cand_in(i).pt;
      end if;
      muon_cand_comb(i).sector <= muon_cand_in(i).sector;
      muon_cand_comb(i).roi    <= muon_cand_in(i).roi;
    end loop;
  end process veto;

  reg : process (clk, rst) is
  begin
    if (rst = '1') then
      source_valid  <= '0';
      muon_cand_out <= (others => MuonCandidate'(sector | roi | pt => (others => '0')));
    else
      if rising_edge(clk) then
        if (sink_valid = '1') then
          source_valid  <= '1';
          muon_cand_out <= muon_cand_comb;
        else
          source_valid <= '0';
        end if;
      end if;
    end if;
  end process reg;

end architecture behavior;
