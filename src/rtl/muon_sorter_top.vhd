-------------------------------------------------------------------------------
-- Title      : Muon candidate sorter
-- Project    : MUCTPI-L1Topo interface
-------------------------------------------------------------------------------
-- File       : muon_sorter_top.vhd
-- Author     : Stefan Haas
-- Company    : CERN PH-ATE
-- Created    : 12-07-13
-- Last update: 2018-11-08
-- Platform   : Windows XP
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Top level with input register for synthesis
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

entity muon_sorter_top is

  generic (output_number : integer := 2);  -- number of sorted candidates

  port (clk          : in  std_logic;
        rst          : in  std_logic;
        sink_valid   : in  std_logic;
        source_valid : out std_logic;
        muon_cand    : in  MuonCandidateArray(0 to CandidateNumber-1);
        top_cand     : out MuonCandidateArray(0 to output_number-1));

end entity muon_sorter_top;

-------------------------------------------------------------------------------

architecture behavior of muon_sorter_top is

  signal muon_cand_reg : MuonCandidateArray(muon_cand'range);

begin  -- architecture behavior

  sorter_1 : entity work.muon_sorter
    generic map (num_in  => muon_cand'length,
                 num_out => output_number)
    port map (clk          => clk,
              rst          => rst,
              sink_valid   => sink_valid,
              source_valid => source_valid,
              muon_cand    => muon_cand_reg,
              top_cand     => top_cand);

  in_out_regs_p : process is
  begin  -- process
    wait until rising_edge(clk);
    muon_cand_reg <= muon_cand;
  end process in_out_regs_p;

end architecture behavior;

