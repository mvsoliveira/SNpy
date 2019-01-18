----------------------------------------------------------------------------------------------------------------------
-- Title      : Tap-configurable shift register
-- Project    : MUCTPI

----------------------------------------------------------------------------------------------------------------------
-- File       : shift_reg_tap.vhd
-- Author     : Marcos Oliveira
-- Company    : CERN
-- Created    : 2018-05-02
-- Last update: 2018-05-11
-- Platform   : Vivado 2017.2 and Mentor Modelsim SE-64 10.4a
-- Standard   : VHDL'93/02
----------------------------------------------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 CERN
----------------------------------------------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-05-02  1.0      msilvaol        Created
----------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_reg_tap is

  generic (
    dw : positive := 1;                 -- data width
    tw : positive := 1);                -- tap port width

  port (
    clk    : in  std_logic;                         -- clock
    ce     : in  std_logic                       := '1';
    tap    : in  std_logic_vector(tw-1 downto 0) := (others => '1');
    input  : in  std_logic_vector(dw-1 downto 0);   -- input vector
    output : out std_logic_vector(dw-1 downto 0));  -- output vector

end entity shift_reg_tap;

architecture rtl of shift_reg_tap is

  type sr_t is array (integer range <>) of std_logic_vector;
  signal sr : sr_t(0 to 2**tw-1)(dw-1 downto 0);
  
  attribute shreg_extract : string;
  attribute shreg_extract of sr : signal is "no";

begin  -- architecture rtl



  sr_p : process (all) is
  begin
    sr(0) <= input;
    if rising_edge(clk) then
      for i in 1 to 2**tw-1 loop
        sr(i) <= sr(i-1);
      end loop;
    end if;
  end process sr_p;


  output <= sr(to_integer(unsigned(tap)));

end architecture rtl;
