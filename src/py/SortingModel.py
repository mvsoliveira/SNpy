
from SortingUtils import SortingUtils
import os
import re
import pandas as pd

class SortingModel:
    def __init__(self):
        # getting parameters from makefile
        vsim_args_str = os.environ['VSIM_ARGS']
        self.toplevel = os.environ['TOPLEVEL']
        #vsim_args_str = "-gI=352 -gO=16 -gdelay=5 -gDA=2 -gDB=3"
        vsim_args_m = re.finditer(r"-g([^=]+)=([^ -]+)", vsim_args_str, re.MULTILINE)
        for matchNum, match in enumerate(vsim_args_m, start=1):
            setattr(self, match.group(1), int(match.group(2)))
        #generating simulation models
        self.SU = SortingUtils()
        self.net_sets = (
            I, O, self.presort_in_sets, self.used_out_set, self.nonsorted_out_set) = self.SU.get_muctpi_opt_sets(
            self.I)
        if self.toplevel == 'work.csn_sort_88_64':
            self.net_sets_88 = self.SU.get_muctpi_opt_sets(88)
            [self.list_of_pairs_88, net] = self.SU.get_opt_net(gen_plots=False, net_sets=self.net_sets_88)
            self.net_sets_64 = self.SU.get_muctpi_opt_sets(64)
            [self.list_of_pairs_64, net] = self.SU.get_opt_net(gen_plots=False, net_sets=self.net_sets_64)
        elif self.toplevel == 'work.csn_sort_v2':
            df = pd.read_pickle('../../../in/pickle/I352O016_alhajbaddar22_R_16_oddevenmerge_R_16.pickle')
            [self.list_of_pairs, net] = [df['pairs'][0], df['net'][0]]
        else:
            [self.list_of_pairs, net] = self.SU.get_opt_net(gen_plots=False,
                                                            net_sets=self.net_sets)



if __name__ == "__main__":
    SM = SortingModel()

