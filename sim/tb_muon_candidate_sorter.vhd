-------------------------------------------------------------------------------
-- Title      : Testbench for design "muon_candidate_sorter"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : tb_muon_candidate_sorter.vhd
-- Author     : Stefan Haas
-- Company    : CERN PH-ATE
-- Created    : 17-06-13
-- Last update: 2018-11-08
-- Platform   : Windows XP
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 CERN PH-ATE
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 17-06-13  1.0      haass     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;

use std.textio.all;

use work.RandomPkg.all;
--use work.CoveragePkg.all;

use work.MuctpiDataTypes.all;
use work.MuctpiFunctions.all;

-------------------------------------------------------------------------------

entity tb_muon_candidate_sorter is

end entity tb_muon_candidate_sorter;

-------------------------------------------------------------------------------

architecture testbench of tb_muon_candidate_sorter is

  -- component generics
  constant output_number : integer := 2;

  -- component ports
  signal clk          : std_logic := '1';
  signal rst          : std_logic := '0';
  signal sink_valid   : std_logic := '1';
  signal source_valid : std_logic;
  signal muon_cand    : MuonCandidateArray(0 to CandidateNumber-1);
  signal top_cand     : MuonCandidateArray(0 to output_number-1);

  procedure Message (str : string) is   -- prints string argument to the console
    variable buf : line;
  begin
    write(buf, str);
    writeline(output, buf);
  end;

begin  -- architecture testbench

  -- component instantiation
  DUT : entity work.muon_sorter_top
    generic map (output_number => output_number)
    port map (clk          => clk,
              rst          => rst,
              sink_valid   => sink_valid,
              source_valid => source_valid,
              muon_cand    => muon_cand,
              top_cand     => top_cand);

  -- clock generation
  clk <= not clk after 5 ns;

  -- waveform generation
  stimulus_p : process
    variable RV      : RandomPType;
    variable pt      : CandidatePtArray(muon_cand'range);
    variable valid   : boolean_vector(muon_cand'range);
    variable max_pt  : CandidatePtArray(top_cand'range);
    variable max_idx : CandidateIndexArray(top_cand'range);
    variable buf     : line;
  begin
    while (true) loop
      for i in muon_cand'range loop
        pt(i)               := RV.DistSlv((20, 6, 5, 4, 3, 2, 1, 60), 3);
        valid(i)            := (pt(i) /= O"0") and (pt(i) /= O"7");
        muon_cand(i).sector <= to_stdlogicvector(integer(i/2), 4);
        muon_cand(i).pt     <= pt(i);
        muon_cand(i).roi    <= RV.RandSlv(0, 255, 8);
      end loop;  -- i
      -- find the highest candidates
      max_pt  := (others => O"0");
      max_idx := (others => 25);
      for n in 0 to output_number-1 loop
        for i in pt'range loop
          if (valid(i) and pt(i) >= max_pt(n)) then
            max_pt(n)  := pt(i);
            max_idx(n) := i;
          end if;
        end loop;  -- i
        valid(max_idx(n)) := false;     -- mask the highest candidate
      end loop;  -- n
--      -- find the second highest candidate
--      for i in cand_pt'range loop
--        if (valid(i) and pt(i) >= max_pt(1)) then
--          max_pt(1)  := pt(i);
--          max_idx(1) := i;
--        end if;
--      end loop;  -- i
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      -- display values
      write(buf, string'("pt = [ "));
      for i in muon_cand'range loop
        write(buf, to_ostring(muon_cand(i).pt) & " ");
      end loop;  -- i
      write(buf, "]; max pt = [ " & to_ostring(max_pt(0)) & "," & to_ostring(max_pt(1)));
      write(buf, " ]; max idx = [ " & to_string(max_idx(0)) & "," & to_string(max_idx(1)) & " ]; ");
      write(buf, " top pt = [ " & to_ostring(top_cand(0).pt) & "," & to_ostring(top_cand(1).pt) & " ]");
      write(buf, " top sector = [ " & to_string(to_integer(top_cand(0).sector)) & "," & to_string(to_integer(top_cand(1).sector)) & " ]");
      writeline(output, buf);
      -- check the output
      for i in 0 to output_number-1 loop
        if (pt_valid(max_pt(i))) then   -- check if there is a candidate
          assert (top_cand(i).pt = max_pt(i))
            report "pt mismatch: " & to_ostring(top_cand(i).pt) & " expected " & to_ostring(max_pt(i))
            severity warning;
          assert (top_cand(i).roi = muon_cand(max_idx(i)).roi)
            report "index mismatch: " & to_string(to_integer(top_cand(i).roi)) & ", expected " & to_string(to_integer(muon_cand(max_idx(i)).roi))
            severity warning;
        end if;
      end loop;  -- i
    end loop;
  end process stimulus_p;

end architecture testbench;
