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

architecture hier of csn_net is

  constant R   : natural := 16;
  constant I_s : natural := 22;
  constant I_m : natural := 32;

  type muon_2d is array (natural range <>) of muon_a(0 to O - 1);
  signal muon_R  : muon_2d(0 to R-1);
  signal muon_M1 : muon_2d(0 to R/2-1);
  signal muon_M2 : muon_2d(0 to R/4-1);
  signal muon_M3 : muon_2d(0 to R/8-1);

  signal source_valid_r  : std_logic_vector(0 to R-1);
  signal source_valid_m1 : std_logic_vector(0 to R/2-1);
  signal source_valid_m2 : std_logic_vector(0 to R/4-1);
  signal source_valid_m3 : std_logic_vector(0 to R/8-1);


begin

  -- sorting step
  R_g : for Ri in 0 to R-1 generate
    csn_inst : entity work.csn
      generic map(
        I     => I_s,
        O     => O,
        delay => D,
        Off   => 0
        )
      port map(
        clk          => clk,
        sink_valid   => sink_valid,
        source_valid => source_valid_r(Ri),
        muon_i       => muon_i(Ri*I_S to ((Ri+1)*I_s-1)),
        muon_o       => muon_R(Ri)
        );

  end generate R_g;

  -- merging step 1
  M1_g : for Mi in 0 to R/2-1 generate
    csn_inst : entity work.csn
      generic map(
        I     => I_m,
        O     => O,
        delay => D,
        Off   => 12
        )
      port map(
        clk              => clk,
        sink_valid       => source_valid_r(2*Mi),
        source_valid     => source_valid_m1(Mi),
        muon_i(0 to 15)  => muon_R(2*Mi),
        muon_i(16 to 31) => muon_R(2*Mi+1),
        muon_o           => muon_M1(Mi)
        );

  end generate M1_g;

  -- merging step 2
  M2_g : for Mi in 0 to R/4-1 generate
    csn_inst : entity work.csn
      generic map(
        I     => I_m,
        O     => O,
        delay => D,
        Off   => 17
        )
      port map(
        clk              => clk,
        sink_valid       => source_valid_m1(2*Mi),
        source_valid     => source_valid_m2(Mi),
        muon_i(0 to 15)  => muon_M1(2*Mi),
        muon_i(16 to 31) => muon_M1(2*Mi+1),
        muon_o           => muon_M2(Mi)
        );

  end generate M2_g;

  -- merging step 3
  M3_g : for Mi in 0 to R/8-1 generate
    csn_inst : entity work.csn
      generic map(
        I     => I_m,
        O     => O,
        delay => D,
        Off   => 22
        )
      port map(
        clk              => clk,
        sink_valid       => source_valid_m2(2*Mi),
        source_valid     => source_valid_m3(Mi),
        muon_i(0 to 15)  => muon_M2(2*Mi),
        muon_i(16 to 31) => muon_M2(2*Mi+1),
        muon_o           => muon_M3(Mi)
        );

  end generate M3_g;

  -- merging step 4
  csn_inst : entity work.csn
    generic map(
      I     => I_m,
      O     => O,
      delay => D,
      Off   => 27
      )
    port map(
      clk              => clk,
      sink_valid       => source_valid_m3(0),
      source_valid     => source_valid,
      muon_i(0 to 15)  => muon_M3(0),
      muon_i(16 to 31) => muon_M3(1),
      muon_o           => muon_o
      );





end architecture hier;
