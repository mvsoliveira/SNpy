library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.csn_pkg.all;

entity csn_net is
  generic(
    I : natural := 352;
    O : natural := 16;
    D : natural := 3  -- delay in clock cycles for pipeline register                
    );

  port(
    clk          : in  std_logic;
    sink_valid   : in  std_logic;
    source_valid : out std_logic;
    muon_i       : in  muon_a(0 to I - 1);
    muon_o       : out muon_a(0 to O - 1)
    );
end entity csn_net;

architecture flat of csn_net is


  signal muon_cand : muon_sort_a(0 to I - 1);

  signal muon_stage_b : muon_sort_a(0 to O - 1);

  signal source_valid_a : std_logic_vector(0 to 3);
  signal sink_valid_int : std_logic;
  signal sink_valid_b   : std_logic;
  signal source_valid_b : std_logic;

  type mux_int_a_t is array (natural range <>) of integer range 0 to I - 1;
  signal mux_int_a : mux_int_a_t(0 to O - 1);

  type muon_2d is array (natural range <>) of muon_a(0 to I - 1);
  signal muon_int : muon_2d(0 to D);

begin


  csn_inst : entity work.csn
    generic map(
      I     => I,
      O     => O,
      delay => D,
      Off   => 0
      )
    port map(
      clk          => clk,
      sink_valid   => sink_valid,
      source_valid => source_valid,
      muon_i       => muon_i,
      muon_o       => muon_o
      );


end architecture flat;
