-------------------------------------------------------------------------------
-- Title      : MUCTPI data types
-- Project    : MUCTPI-L1Topo interface
-------------------------------------------------------------------------------
-- File       : MuctpiDataTypes.vhd
-- Author     : Stefan Haas
-- Company    : CERN PH-ATE
-- Created    : 12-07-13
-- Last update: 2018-11-08
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

package MuctpiDataTypes is

  constant CandidateNumber : natural := 52;
  subtype CandidateIndex is natural range 0 to CandidateNumber-1;
  subtype CandidateIndexValue is std_logic_vector(4 downto 0);

  subtype CandidatePtValue is std_logic_vector(3 downto 0);

  constant SectorNumber : natural := 13;
  subtype SectorIndex is integer range 0 to SectorNumber-1;
  subtype SectorIndexValue is std_logic_vector(3 downto 0);

  subtype RoiNumber is integer range 0 to 255;
  subtype RoiNumberValue is std_logic_vector(7 downto 0);

  type MuonCandidate is record
    sector : SectorIndexValue;
    pt     : CandidatePtValue;
    roi    : RoiNumberValue;
  end record;

  type MuonCandidateArray is array (natural range <>) of MuonCandidate;

  type CandidatePtArray is array (natural range <>) of CandidatePtValue;

  type CandidateIndexArray is array (natural range <>) of CandidateIndex;

  subtype MuonCandidateBitStream is std_logic_vector(7 downto 0);

  type MuonCandidateArrayBitStream is array (natural range <>) of MuonCandidateBitStream;

  type MuonCandidateEncoded is record
    eta : integer range 0 to 7;
    phi : integer range 0 to 7;
    pt  : integer range 0 to 3;
  end record;

  type MuonCandidateEncodedArray is array (natural range <>) of MuonCandidateEncoded;

  type CandidateRoiArray is array (natural range <>) of RoiNumberValue;

  subtype l1topo_register_addr_t is std_logic_vector (2 downto 0);

  constant l1topo_mode_addr         : l1topo_register_addr_t := o"0";
  constant l1topo_fixed_phrase_addr : l1topo_register_addr_t := o"1";
  constant l1topo_no_cand_word_addr : l1topo_register_addr_t := o"2";

  subtype l1topo_mode_t is std_logic_vector (1 downto 0);
  constant l1topo_prbs_mode         : l1topo_mode_t := "00";
  constant l1topo_fixed_phrase_mode : l1topo_mode_t := "01";
  constant l1topo_muon_cand_mode    : l1topo_mode_t := "10";
  constant l1topo_init_mode         : l1topo_mode_t := l1topo_prbs_mode;


  type l1topo_ctrl_reg_t is record
    mode         : std_logic_vector(1 downto 0);
    fixed_phrase : std_logic_vector(31 downto 0);
    no_cand_word : std_logic_vector(7 downto 0);
  end record;

  constant prbs_level : positive := 31;
  constant second_tap : positive := 28;
  
end package MuctpiDataTypes;

