----------------------------------------------------------------------------------------------------------------------
-- Title      : wrapper
-- Project    : MUCTPI

----------------------------------------------------------------------------------------------------------------------
-- File       : wrapper.vhd
-- Author     : Marcos Oliveira
-- Company    : CERN
-- Created    : 2018-12-05
-- Last update: 2018-12-05
-- Platform   : Vivado 2017.2 and Mentor Modelsim SE-64 10.4a
-- Standard   : VHDL'93/02
----------------------------------------------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 CERN
----------------------------------------------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-12-05  1.0      msilvaol        Created
----------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity wrapper is

  generic (
    N : natural := 0);

  port (
    clk_wrapper : in  std_logic;
    clk_user    : in  std_logic;
    input       : in  std_logic;
    output      : out std_logic);

end entity wrapper;

architecture rtl of wrapper is

  component lfsr is
    generic (
      WIDTH : natural);
    port (
      clock         : in  std_logic;
      input_bit     : in  std_logic;
      output_vector : out std_logic_vector(WIDTH-1 downto 0));
  end component lfsr;

  component reducer is
    generic (
      input_width_log4 : natural);
    port (
      clock        : in  std_logic;
      input_vector : in  std_logic_vector(4**input_width_log4-1 downto 0);
      output_bit   : out std_logic);
  end component reducer;

  signal input_vector  : std_logic_vector(16-1 downto 0);
  signal output_vector : std_logic_vector(16-1 downto 0);

  attribute DONT_TOUCH              : string;
  attribute DONT_TOUCH of lsfr_1    : label is "TRUE";
  attribute DONT_TOUCH of reducer_1 : label is "TRUE";





begin  -- architecture rtl

  lsfr_1 : lfsr
    generic map (
      WIDTH => 16)
    port map (
      clock         => clk_wrapper,
      input_bit     => input,
      output_vector => input_vector);

  reducer_1 : reducer
    generic map (
      input_width_log4 => 2)
    port map (
      clock        => clk_wrapper,
      input_vector => output_vector,
      output_bit   => output);

  ----------------------------------------------------------------------------------------------------------------------
  -- Logic being tested
  ----------------------------------------------------------------------------------------------------------------------

  process (clk_user) is
  begin
    if rising_edge(clk_user) then
      output_vector <= input_vector;
    end if;
  end process;


end architecture rtl;

