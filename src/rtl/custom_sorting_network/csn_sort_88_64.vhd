library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.csn_pkg.all;

entity csn_sort_88_64 is
	generic(
		I  : natural := 352;
		O  : natural := 16;
		DA : natural := 3;              -- delay in clock cycles for pipeline register
		DB : natural := 3               -- delay in clock cycles for pipeline register
	);

	port(
		clk          : in  std_logic;
		sink_valid   : in  std_logic;
		source_valid : out std_logic;
		muon_i       : in  muon_a(0 to I - 1);
		muon_o       : out muon_a(0 to O - 1)
	);
end entity csn_sort_88_64;

architecture RTL of csn_sort_88_64 is

	constant IA : natural := 88;
	constant IB : natural := 64;

	signal muon_cand    : muon_sort_a(0 to I - 1);
	signal muon_stage_a : muon_sort_a(0 to (I / IA) * O - 1);
	signal muon_stage_b : muon_sort_a(0 to O - 1);

	signal source_valid_a : std_logic_vector(0 to 3);
	signal sink_valid_b   : std_logic;
	signal source_valid_b   : std_logic;

	type mux_int_a_t is array (natural range <>) of integer range 0 to I - 1;
	signal mux_int_a : mux_int_a_t(0 to O - 1);
	
	type muon_2d is array (natural range <>) of muon_a(0 to I - 1);
	signal muon_int : muon_2d(0 to DA + DB);

begin

	id_g : for id in 0 to I - 1 generate

		muon_cand(id).idx <= std_logic_vector(to_unsigned(id, IDX_WIDTH));
		muon_cand(id).pt  <= muon_i(id).pt;

	end generate id_g;

	stage_a_g : for id in 0 to I / IA - 1 generate

		csn_inst : entity work.csn
			generic map(
				I     => IA,
				O     => O,
				delay => DA
			)
			port map(
				clk          => clk,
				sink_valid   => sink_valid,
				source_valid => source_valid_a(id),
				muon_i       => muon_cand(id * IA to (id + 1) * IA - 1),
				muon_o       => muon_stage_a(id * O to (id + 1) * O - 1)
			);

	end generate stage_a_g;

	sink_valid_b <= source_valid_a(0);

	stage_b_csn_inst : entity work.csn
		generic map(
			I     => IB,
			O     => O,
			delay => DB
		)
		port map(
			clk          => clk,
			sink_valid   => sink_valid_b,
			source_valid => source_valid_b,
			muon_i       => muon_stage_a,
			muon_o       => muon_stage_b
		);
		
		input_delay: block
        begin
		
		-- delaying input and source_valid
    	process(all)
            begin
                muon_int(0) <= muon_i;
                if rising_edge(clk) then
                    -- delaying muon input
                    for i in 1 to DA+DB loop
                            muon_int(i) <= muon_int(i-1);
                          end loop;
                          source_valid <= source_valid_b;               
                end if;
            end process;	
            end block input_delay; 	
		
		
    mux : block
                    begin

	o_g : for id in 0 to O - 1 generate

		process(all)
		begin
			mux_int_a(id) <= to_integer(unsigned(muon_stage_b(id).idx));
			if rising_edge(clk) then
				-- avoiding mux for idx and pt as it goes through the network
				muon_o(id).idx   <= muon_stage_b(id).idx;
				muon_o(id).pt    <= muon_stage_b(id).pt;
				-- using mux for roi and flags as it does not goes through the network
				muon_o(id).roi   <= muon_int(DA+DB)(mux_int_a(id)).roi;
				muon_o(id).flags <= muon_int(DA+DB)(mux_int_a(id)).flags;
			end if;
		end process;

	end generate o_g;
	
	end block mux; 	

end architecture RTL;
