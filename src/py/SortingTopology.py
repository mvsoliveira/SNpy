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
        #self.get_topology_df()
        #print(self.topology_df[self.topology_cols])
        #ST.topology_df[ST.topology_cols]



    def get_net(self, I, O,method):
        net_sets = self.SU.get_net_opt_sets(I=I, O=O, pI=None, nO=None)
        [list_of_pairs, net] = self.SU.get_opt_net(gen_plots = False, net_sets=net_sets, method=method)
        return [list_of_pairs, net]

    def get_merge_dict(self, method = 'oddevenmerge'):
        Im=2*self.O
        Om = self.O
        # getting masked net
        net_sets = self.SU.get_net_opt_sets(I=Im, O=Om, pI=None, nO=None)
        masked_plotnet3v2 = self.SU.generate_opt_masked_net(*net_sets, method)
        masked_pairs = self.SU.to_list_of_pairs(masked_plotnet3v2, remove_masked=False)
        # plot it anyways
        self.SU.plot(masked_plotnet3v2)
        # getting optimized net
        [opt_list_of_pairs, opt_net] = self.get_net(I=Im, O=self.O, method = method)
        self.merge_dict = {'pairs': opt_list_of_pairs,
                           'net': opt_net,
                           'masked_pairs' : masked_pairs,
                           'masked_net': masked_plotnet3v2,
                           'method' : method,
                           'cm' : len(opt_list_of_pairs),
                           'dm' : len(opt_net),
                           'Im' : Im,
                           'Om': Om}



    def get_topology_df(self):
        for R in self.R_range:
            print('Working with R={R:d}'.format(R=R))
            ceil_I_R = np.math.ceil(self.I/R)
            method = self.SU.get_method(ceil_I_R, self.method)
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

    def remap_pair(self,pair,mymap):
        # this way keep mask if exist
        new_pair = pair.copy()
        new_pair[0] = mymap[pair[0]]
        new_pair[1] = mymap[pair[1]]
        return new_pair

    def remap_list_of_pairs(self,list_of_pairs,mymap):
        new_list_of_pairs = []
        for pair in list_of_pairs:
            new_list_of_pairs.append(self.remap_pair(pair,mymap))
        return new_list_of_pairs

    def interleave_list_of_list_of_pairs(self, list_of_list_of_pairs):
        return [*sum(zip(*list_of_list_of_pairs),())]

    def test_method(self):
        l = [
            [(1,2,0),(3,4,1)],
            [(5, 6, 0), (7, 8, 0)],
            [(9, 10, 1), (11, 12, 1)]
        ]
        print(self.interleave_list_of_list_of_pairs(l))

    def generate_R_sort_net(self, R):
        # finding the integer ceiling value of I/R
        ceil_I_R = np.math.ceil(self.I / R)
        # getting the appropriate optimization settings
        net_sets = self.SU.get_net_opt_sets(I=ceil_I_R, O=self.O, pI=None, nO=None)
        # getting net with masked comparisons
        plotnet3v2 = self.SU.generate_opt_masked_net(*net_sets, method=self.method)
        # converting net to list of pairs
        list_of_pairs = self.SU.to_list_of_pairs(plotnet3v2, remove_masked= False)
        list_of_list_of_pairs = []
        # replicating net
        for r in range(R):
            mymap = list(range(r*ceil_I_R,(r+1)*ceil_I_R))
            list_of_list_of_pairs.append(self.remap_list_of_pairs(list_of_pairs,mymap))

        # interleaving list of pairs to a single list
        new_list_of_pairs = self.interleave_list_of_list_of_pairs(list_of_list_of_pairs)
        # adding metadata
        new_list_of_pairsv2 = {'method' : '{m:s}_R_{R:d}'.format(m=plotnet3v2['method'],R=R),
                               'I' : self.I,
                               'O' : self.O*R,
                               'pairs' : new_list_of_pairs}
        # finding the stages
        netv2 = self.SU.to_stages(new_list_of_pairsv2)
        # creating plotnet object (adding substages)
        plotnetv2 = self.SU.to_plotnet(netv2)
        return [new_list_of_pairsv2, plotnetv2]

    def is_power_2(self, n):
        return ((n & (n - 1) == 0) and n != 0)

    def generate_R_merge_net(self,R):
        merge_pairs = self.merge_dict['masked_pairs']
        merge_tree_pairs = []
        # define donly if R is power of two
        if self.is_power_2(R):
            I_R = self.I // R
            O = self.O
            for L in range(int(np.math.log2(R))):
                level_pairs = []
                for r in range(0,R >> L,2):
                    # computing first and second range os input of merge net
                    first_range = range(r*(I_R << L), r * (I_R << L)+O)
                    second_range = range((r+1) * (I_R << L), (r+1) * (I_R << L) + O)

                    mymap = list(first_range)+list(second_range)
                    # remapping net to new input mapping
                    level_pairs.append(self.remap_list_of_pairs(merge_pairs, mymap))
                    print(L, r)
                # interleaving pairs
                merge_tree_pairs.extend(self.interleave_list_of_list_of_pairs(level_pairs))

        # adding metadata
        new_list_of_pairsv2 = {'method': '{m:s}_R_{R:d}'.format(m=self.merge_dict['method'], R=R),
                               'I': self.I,
                               'O': self.O,
                               'pairs': merge_tree_pairs}
        # finding the stages
        netv2 = self.SU.to_stages(new_list_of_pairsv2)
        # creating plotnet object (adding substages)
        plotnetv2 = self.SU.to_plotnet(netv2)
        return [new_list_of_pairsv2, plotnetv2]




    def generate_R_net(self, R):
        # generating the sorting net (first stage)
        [sort_list_of_pairsv2, sort_plotnetv2] = self.generate_R_sort_net(R)
        # plotting it anyaways
        self.SU.plot(sort_plotnetv2)
        # validation if it is a single net
        if R == 1:
            net_sets = self.SU.get_net_opt_sets(I=sort_list_of_pairsv2['I'], O=sort_list_of_pairsv2['O'], pI=None, nO=None)
            self.SU.list_of_pairs_validation(net_sets=net_sets,list_of_pairsv2=sort_list_of_pairsv2, N=1000)
        # generating merging tree net
        [merge_list_of_pairsv2, merge_plotnetv2] = self.generate_R_merge_net(R)
        # plotting it anyaways
        self.SU.plot(merge_plotnetv2)











        # cs = len(list_of_pairs)
        # ds = len(net)
        # Ecs = R * cs
        # ceilLgR = np.math.ceil(np.math.log(R, 2))
        # R_1 = R - 1
        # Ecm = R_1 * self.merge_dict['cm']
        # Edm = ceilLgR * self.merge_dict['dm']










if __name__ == '__main__':
    ST = SortingTopology(I=16,O=4,method='best')
    ST.generate_R_net(4)
    #ST.generate_R_merge_net(1)
    print('finished')


