from SortingUtils import SortingUtils
import numpy as np
import pandas as pd
# if True:
#     for i in range(88,89):
#         #print(i)
#         I = i
#         net_sets = (I, O, presort_in_sets, used_out_set, nonsorted_out_set) = SU.get_muctpi_opt_sets(I, O=I, presort=False)
#         #(I, O, presort_in_sets, used_out_set, nonsorted_out_set) = net_sets
#         [list_of_pairs, net] = SU.get_muctpi_sel_net(False, net_sets, method='oddevenp2')
#         eq = cM(I)
#         opt = len(list_of_pairs)
#         if eq != opt:
#             print('Failed I={i:d}: Compare C from eq: {eq:d}, from opt: {opt:d}.'.format(i=i,eq=eq,opt=opt))
#
#             #print(list_of_pairs)

class SortingTopology:
    def __init__(self, I, O, method):
        self.SU = SortingUtils()
        self.I = I
        self.O = O
        self.method = method
        self.R_range = range(1,np.math.ceil(I//O)+1)
        self.topology_cols = ['R','ceilI_R','method','cs','ds','Ecs','ceilLgR','R-1','Ecm','Edm','Ec','Ed']
        self.topology_df = pd.DataFrame(dtype=int)
        self.get_merge_dict()
        self.get_topology_df()
        print(self.topology_df[self.topology_cols])
        #ST.topology_df[ST.topology_cols]


    def get_net(self, I, O,method):
        net_sets = self.SU.get_net_opt_sets(I=I, O=O, pI=None, nO=None)
        [list_of_pairs, net] = self.SU.get_muctpi_sel_net(gen_plots = False, net_sets=net_sets, method=method)
        return [list_of_pairs, net]

    def get_merge_dict(self):
        Im=2*self.O
        Om = self.O
        [list_of_pairs, net] = self.get_net(I=Im, O=self.O, method = 'oddevenmerge')
        self.merge_dict = {'pairs': list_of_pairs,
                           'net': net,
                           'cm' : len(list_of_pairs),
                           'dm' : len(net),
                           'Im' : Im,
                           'Om': Om}

    def get_best_method(self,N):
        if N == 16:
            method = 'vanvoorhis16'
        elif N==18:
            method = 'alhajbaddar18'
        elif N==22:
            method = 'alhajbaddar22'
        else:
            method = 'mergesort'
        return method

    def get_topology_df(self):
        for R in self.R_range:
            print('Working with R={R:d}'.format(R=R))
            ceil_I_R = np.math.ceil(self.I/R)
            if self.method == 'best':
                method = self.get_best_method(ceil_I_R)
            else:
                method = self.method
            [list_of_pairs, net] = self.get_net(ceil_I_R, self.O, method)
            cs = len(list_of_pairs)
            ds = len(net)
            Ecs = R*cs
            ceilLgR = np.math.ceil(np.math.log(R,2))
            R_1 = R-1
            Ecm = R_1*self.merge_dict['cm']
            Edm = ceilLgR*self.merge_dict['dm']

            self.topology_df = self.topology_df.append({
                'R' : np.int64(R),
                'ceilI_R' : ceil_I_R,
                'method' : method,
                'cs' : cs,
                'ds' : ds,
                'Ecs' : Ecs,
                'ceilLgR' : ceilLgR,
                'R-1' : R_1,
                'Ecm' : Ecm,
                'Edm' : Edm,
                'Ec' : Ecs+Ecm,
                'Ed' : ds+Edm
            },ignore_index=True)
        for i in ['R', 'ceilI_R', 'cs', 'ds', 'Ecs', 'ceilLgR', 'R-1', 'Ecm', 'Edm', 'Ec', 'Ed']:
            self.topology_df[i] = self.topology_df[i].astype(int)
        self.topology_df[self.topology_cols].to_excel('topology.xlsx')





if __name__ == '__main__':
    ST = SortingTopology(I=352,O=16,method='best')
    print('finished')


