from SortingUtils import SortingUtils
from itertools import chain
import random
import pandas as pd
import copy


class SortingHLS (SortingUtils):
    def __init__(self, I, O, method, generate_plot = False, plot_masked_pairs = True, figsize=None, title=None):
        self.SU = SortingUtils()
        self.I = I
        self.O = O
        self.N = 1000
        self.ptlen = 4
        self.idxlen = 9
        self.roilen = 8
        self.flagslen = 4
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

        self.dependence_test_352()
        # creating header
        self.create_header()
        # Creating Stimullus
        self.gen_muon()
        # Computing expected result
        self.py_net_sort_muon()
        self.create_test()





    def create_header(self):
        with open('../../in/cpp/pairs_template.h') as content_file:
            template = content_file.read()

        template = template.replace('<HEADER_NAME>','PAIRS_{0:d}_{1:d}'.format(self.I,self.O))
        template = template.replace('<I>', '{0:d}'.format(self.I))
        template = template.replace('<O>', '{0:d}'.format(self.O))
        template = template.replace('<NP>', '{0:d}'.format(len(self.list_of_pairs)))

        pairs_str = ['{{{0:d},{1:d}}}'.format(*p) for p in self.list_of_pairs]
        pairs_out = ',\n'.join(pairs_str)
        template = template.replace('<PAIRS>', pairs_out)

        with open('../../out/cpp/pairs_{0:d}_{1:d}.h'.format(self.I,self.O), 'w') as content_file:
            content_file.write(template)

    def create_test(self):
        lines = []
        for i in range(self.N):
            lines.append(' '.join(['{pt:d} {roi:d} {flags:d}'.format(pt=self.muon_cand[i][_]['pt'], roi=self.muon_cand[i][_]['roi'], flags=self.muon_cand[i][_]['flags']) for _ in range(self.I)]) + ' ' +
            ' '.join(['{id:d} {pt:d} {roi:d} {flags:d}'.format(id=self.py_net_sorted_muon[i][_]['idx'], pt=self.py_net_sorted_muon[i][_]['pt'], roi=self.py_net_sorted_muon[i][_]['roi'], flags=self.py_net_sorted_muon[i][_]['flags']) for _ in range(self.O)]))

        str = '\n'.join(lines)
        with open('../../out/dat/test_{0:d}_{1:d}.dat'.format(self.I, self.O), 'w') as content_file:
            content_file.write(str)

    def gen_muon(self):
        self.muon_cand = []
        for i in range(self.N):
            cand = []
            for j in range(self.I):
                cand.append({'pt': random.randint(0, -1 + 2 ** self.ptlen),
                             'idx': j,
                             'roi': random.randint(0, -1 + 2 ** self.roilen),
                             'flags': random.randint(0, -1 + 2 ** self.flagslen),
                             })

            self.muon_cand.append(cand)
        pd.DataFrame(self.muon_cand).to_csv('../../out/csv/stim_{0:d}_{1:d}.csv'.format(self.I,self.O))

    def py_net_sort_muon(self):
        # copying list
        self.py_net_sorted_muon = copy.deepcopy(self.muon_cand)
        for i in range(self.N):
            for j in self.list_of_pairs: self.compare_and_swap(self.py_net_sorted_muon[i], *j, key=lambda k: k['pt'])
            self.py_net_sorted_muon[i] = self.py_net_sorted_muon[i][0:self.O]

        pd.DataFrame(self.muon_cand).to_csv('../../out/csv/expec_{0:d}_{1:d}.csv'.format(self.I,self.O))

    def dependence_test_352(self):
        print(len(self.net))
        self.test_pairs = []
        for i in range(16):
            members = list(range(i*22,(i+1)*22))
            for j in range(12):
                for p in self.net[j]:
                    if p[0] in members:
                        self.test_pairs.append(p)
        print(len(self.test_pairs))
        for j in range(12,32):
            for p in self.net[j]:
                self.test_pairs.append(p)
        self.list_of_pairs = self.test_pairs

        print(len(self.test_pairs))








if __name__ == '__main__':
    SH = SortingHLS(I=352, O=16, method='I352O016_alhajbaddar22_R_16_oddevenmerge_R_16.pickle')
    #SH = SortingHLS(I=22, O=16, method='I022O016_alhajbaddar22.pickle')
    #SH = SortingHLS(I=32, O=16, method='I032O016_oddevenmerge.pickle')
    #SH = SortingHLS(I=4, O=4, method='I004O004_oddevenp2_R_1_oddevenmerge_R_1.pickle')

