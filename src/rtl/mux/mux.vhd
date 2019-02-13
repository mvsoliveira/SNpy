library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mux_pkg.all;

entity mux is
	generic(
		AW    : natural := 12;
		DW    : natural := 32;
		delay : natural := 3            -- delay in clock cycles for pipeline register
	);
	port(
		clk          : in  std_logic;
		sel          : in  std_logic_vector(AW - 1 downto 0);
		input        : in  array2d(0 to 2**AW - 1)(DW - 1 downto 0);
		sink_valid   : in  std_logic;
		source_valid : out std_logic;
		output       : out std_logic_vector(DW - 1 downto 0)
	);
end entity mux;

architecture RTL of mux is

	signal output_comb : std_logic_vector(DW - 1 downto 0);

	-- pipeline

	type sr_t is array (integer range <>) of std_logic_vector(DW - 1 downto 0);
	signal sr   : sr_t(0 to delay);
	signal sr_v : std_logic_vector(0 to delay);

	attribute shreg_extract : string;
	attribute shreg_extract of sr : signal is "no";
	attribute shreg_extract of sr_v : signal is "no";

	attribute syn_srlstyle : string;
	attribute syn_srlstyle of sr : signal is "registers";
	attribute syn_srlstyle of sr_v : signal is "registers";

begin

	output_comb <= input(to_integer(unsigned(sel)));

	sr_p : process(all) is
	begin
		sr(0)   <= output_comb;
		sr_v(0) <= sink_valid;
		if rising_edge(clk) then
			for i in 1 to delay loop
				sr(i)   <= sr(i - 1);
				sr_v(i) <= sr_v(i - 1);
			end loop;
		end if;
	end process sr_p;

	output       <= sr(delay);
	source_valid <= sr_v(delay);

end architecture RTL;
