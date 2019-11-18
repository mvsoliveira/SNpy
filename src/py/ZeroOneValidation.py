from SortingUtils import SortingUtils
import pandas as pd

SU = SortingUtils()


###################
# odd 32-16
###################

if False:
    N = 32
    O = 16
    method = 'oddevenmerge'
    plotnet3v2 = SU.generate_opt_masked_net(N, O, presort_in_sets=(set()), used_out_set=set(range(O)), nonsorted_out_set=None, method=method)
    list_of_pairs = SU.to_list_of_pairs(plotnet3v2,remove_masked=True)
    list_of_pairsv2 = {'method' : plotnet3v2['method'],
                              'I' : N,
                              'O' : O,
                              'pairs' : list_of_pairs}

    #list_of_pairs2['pairs'].pop()
    result = SU.zeroone_validation(list_of_pairsv2)


###################
# baddar 22-16
###################

if False:

    N = 22
    O = 16
    method = 'best'
    plotnet3v2 = SU.generate_opt_masked_net(N, O, presort_in_sets=(set()), used_out_set=set(range(O)), nonsorted_out_set=None, method=method)
    list_of_pairs = SU.to_list_of_pairs(plotnet3v2,remove_masked=True)
    list_of_pairsv2 = {'method' : plotnet3v2['method'],
                              'I' : N,
                              'O' : O,
                              'pairs' : list_of_pairs}

    #list_of_pairs2['pairs'].pop()
    result = SU.zeroone_validation(list_of_pairsv2)

###################
# knuth 12
###################

N = 12
O = 12
method = 'shapiro12'
list_of_pairsv2 = SU.generate_net_pairs(N,methodin=method)
print(list_of_pairsv2)
#list_of_pairsv2['pairs'].pop()
result = SU.zeroone_validation(list_of_pairsv2)
