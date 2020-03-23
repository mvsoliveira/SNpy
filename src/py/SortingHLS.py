from SortingUtils import SortingUtils
import pandas as pd

class SortingHLS:
    def __init__(self, I, O, method, generate_plot = False, plot_masked_pairs = True, figsize=None, title=None):
        self.SU = SortingUtils()
        self.I = I
        self.O = O
        self.title = title
        if figsize is None:
            self.figsize = (4 * 46.8, 4 * 33.1)
        self.method = method
        self.generate_plot = generate_plot
        self.remove_masked_pairs = not plot_masked_pairs
        if 'pickle' in self.method:
            df = pd.read_pickle('../../in/pickle/{method:s}'.format(method=method))
            [self.list_of_pairs, self.net] = [df['pairs'][0], df['net'][0]]
        else:
            net_sets = self.SU.get_net_opt_sets(I=self.I, O=self.O, pI=None, nO=None)
            [self.list_of_pairs, self.net] = self.SU.get_opt_net(gen_plots=self.generate_plot, net_sets=net_sets,
                                                                 method=self.method)
        print(self.list_of_pairs)

if __name__ == '__main__':
    #SH = SortingHLS(I=352, O=16, method='I352O016_alhajbaddar22_R_16_oddevenmerge_R_16.pickle')
    SH = SortingHLS(I=22, O=16, method='I022O016_alhajbaddar22_R_1_oddevenmerge_R_1.pickle')
