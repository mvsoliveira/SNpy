library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.csn_pkg.all;

entity csn_sort_v2 is
	generic(
		I  : natural := 352;
		O  : natural := 16;
		D : natural := 3              -- delay in clock cycles for pipeline register		
	);

	port(
		clk          : in  std_logic;
		sink_valid   : in  std_logic;
		source_valid : out std_logic;
		muon_i       : in  muon_a(0 to I - 1);
		muon_o       : out muon_a(0 to O - 1)
	);
end entity csn_sort_v2;

architecture RTL of csn_sort_v2 is


	signal muon_cand    : muon_sort_a(0 to I - 1);
	
	signal muon_stage_b : muon_sort_a(0 to O - 1);

	signal source_valid_a : std_logic_vector(0 to 3);
	signal sink_valid_int   : std_logic;
	signal sink_valid_b   : std_logic;
	signal source_valid_b : std_logic;

	type mux_int_a_t is array (natural range <>) of integer range 0 to I - 1;
	signal mux_int_a : mux_int_a_t(0 to O - 1);

	type muon_2d is array (natural range <>) of muon_a(0 to I - 1);
	signal muon_int : muon_2d(0 to D);

begin

--	id_g : for id in 0 to I - 1 generate

--		muon_cand(id).idx <= std_logic_vector(to_unsigned(id, IDX_WIDTH));
--		muon_cand(id).pt  <= muon_i(id).pt;

--	end generate id_g;
--  sink_valid_int <= sink_valid;

-- for ooc runs
    process (clk) is
    begin
        if rising_edge(clk) then
            for id in 0 to I - 1 loop
                sink_valid_int <= sink_valid; 
                muon_cand(id).idx <= std_logic_vector(to_unsigned(id, IDX_WIDTH));
                muon_cand(id).pt  <= muon_i(id).pt;                
            end loop;
        end if;
    end process;



		csn_inst : entity work.csn
			generic map(
				I     => I,
				O     => O,
				delay => D
			)
			port map(
				clk          => clk,
				sink_valid   => sink_valid_int,
				source_valid => source_valid_b,
				muon_i       => muon_cand,
				muon_o       => muon_stage_b
			);



	-- delaying input and source_valid
	process(all)
	begin
		muon_int(0) <= muon_i;
		if rising_edge(clk) then
			-- delaying muon input (keeping full thoughput which is actually not necessay)
			-- should be 
			for i in 1 to D loop
				muon_int(i) <= muon_int(i - 1);
			end loop;
			source_valid <= source_valid_b;
		end if;
	end process;

	-- 1 stage mux
	o_g : for id in 0 to O - 1 generate

		process(all)
		begin
			if not is_x(muon_stage_b(id).idx) then
				mux_int_a(id) <= to_integer(unsigned(muon_stage_b(id).idx));
			end if;
			if rising_edge(clk) then
				-- avoiding mux for idx and pt as it goes through the network
				muon_o(id).idx   <= muon_stage_b(id).idx;
				muon_o(id).pt    <= muon_stage_b(id).pt;
				-- using mux for roi and flags as it does not goes through the network
				muon_o(id).roi   <= muon_int(D)(mux_int_a(id)).roi;
				muon_o(id).flags <= muon_int(D)(mux_int_a(id)).flags;
			end if;
		end process;

	end generate o_g;


end architecture RTL;
