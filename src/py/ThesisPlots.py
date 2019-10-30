from SortingUtils import SortingUtils

SU = SortingUtils()
SU.plot_masked_filename_fmt = '../../out/pdf/plot_I{i:03d}_O{o:03d}_{m:s}_thesis.pdf'
###################
# mergesort N= 8
###################
N = 8
method = 'mergesort'
list_of_pairs2 = SU.generate_net_pairs(N, method)
# finding the stages
netv2 = SU.to_stages(list_of_pairs2)
# fixing the order, relevant only for plotting it
net = [[(0, 4), (1, 5), (2, 6), (3, 7)], [(0, 2), (1, 3), (4, 6), (5, 7)], [(2, 4), (3, 5)], [(0, 1), (2, 3), (4, 5), (6, 7)], [(1, 4), (3, 6)], [(1, 2), (3, 4), (5, 6)]]
netv2['net'] = net
# creating plotnet object (adding substages)
plotnetv2 = SU.to_plotnet(netv2)
# creating plotnet3 (adding a third parameter for each comparison)
plotnet3v2 = SU.to_plotnet_triple(plotnetv2)
#SU.inline_fmt = ['$x_{i:d}$'.format(i=i+1) for i in range(N)]
SU.plot(plotnet3v2)

###################
# mergesort N= 8
###################

N = 8
method = 'oddevenmerge'
list_of_pairs2 = SU.generate_net_pairs(N, method)
# finding the stages
netv2 = SU.to_stages(list_of_pairs2)
# fixing the order, relevant only for plotting it
net = [[(0, 4), (1, 5), (2, 6), (3, 7)], [(2, 4), (3, 5)], [(1, 2), (3, 4), (5, 6)]]
netv2['net'] = net
# creating plotnet object (adding substages)
plotnetv2 = SU.to_plotnet(netv2)
# creating plotnet3 (adding a third parameter for each comparison)
plotnet3v2 = SU.to_plotnet_triple(plotnetv2)
#SU.inline_fmt = ['$x_{i:d}$'.format(i=i+1) for i in range(N//2)]
#SU.inline_fmt.extend(['$y_{i:d}$'.format(i=i+1) for i in range(N//2)])
SU.plot(plotnet3v2)

###################
# mergesort N= 2, 4
###################

N = 4
method = 'oddevenp2'
list_of_pairs2 = SU.generate_net_pairs(N, method)
# finding the stages
netv2 = SU.to_stages(list_of_pairs2)
# creating plotnet object (adding substages)
plotnetv2 = SU.to_plotnet(netv2)
# creating plotnet3 (adding a third parameter for each comparison)
plotnet3v2 = SU.to_plotnet_triple(plotnetv2)
#SU.inline_fmt = ['$x_{i:d}$'.format(i=i+1) for i in range(N//2)]
#SU.inline_fmt.extend(['$y_{i:d}$'.format(i=i+1) for i in range(N//2)])
SU.plot(plotnet3v2)

###################
# bitonic and odd-even merge sort N= 2, 4
###################

N = 8
method = 'oddevenp2'
list_of_pairs2 = SU.generate_net_pairs(N, method)
# finding the stages
netv2 = SU.to_stages(list_of_pairs2)
net = [[(0, 1), (2, 3), (4, 5), (6, 7)], [(0, 2), (1, 3), (4, 6), (5, 7)], [(1, 2), (5, 6)], [(0, 4), (1, 5), (2, 6), (3, 7)], [(2, 4), (3, 5)], [(1, 2), (3, 4), (5, 6)]]
netv2['net'] = net
# creating plotnet object (adding substages)
plotnetv2 = SU.to_plotnet(netv2)
# creating plotnet3 (adding a third parameter for each comparison)
plotnet3v2 = SU.to_plotnet_triple(plotnetv2)
SU.plot(plotnet3v2)

N = 8
method = 'bitonicp2'
list_of_pairs2 = SU.generate_net_pairs(N, method)
# finding the stages
netv2 = SU.to_stages(list_of_pairs2)
# creating plotnet object (adding substages)
plotnetv2 = SU.to_plotnet(netv2)
# creating plotnet3 (adding a third parameter for each comparison)
plotnet3v2 = SU.to_plotnet_triple(plotnetv2)
SU.plot(plotnet3v2)

###################
# van worhis and badaar
###################

N = 16
method = 'vanvoorhis16'
list_of_pairs2 = SU.generate_net_pairs(N, method)
# finding the stages
netv2 = SU.to_stages(list_of_pairs2)
# creating plotnet object (adding substages)
plotnetv2 = SU.to_plotnet(netv2)
# creating plotnet3 (adding a third parameter for each comparison)
plotnet3v2 = SU.to_plotnet_triple(plotnetv2)
SU.plot(plotnet3v2)


N = 22
method = 'alhajbaddar22'

list_of_pairs2 = SU.generate_net_pairs(N, method)
# finding the stages
netv2 = SU.to_stages(list_of_pairs2)
# creating plotnet object (adding substages)
plotnetv2 = SU.to_plotnet(netv2)
# creating plotnet3 (adding a third parameter for each comparison)
plotnet3v2 = SU.to_plotnet_triple(plotnetv2)
SU.plot(plotnet3v2)


###################
# oddevenmerge 32
###################

N = 32
O = 16
method = 'oddevenmerge'
plotnet3v2 = SU.generate_opt_masked_net(N, O, presort_in_sets=(set()), used_out_set=set(range(16)), nonsorted_out_set=None, method=method)
SU.plot(plotnet3v2)

###################
# oddevenmerge 8
###################

N = 6
O = 6
method = 'oddevenp2'
plotnet3v2 = SU.generate_opt_masked_net(N, O, presort_in_sets=(set()), used_out_set=set(range(N)), nonsorted_out_set=None, method=method)
SU.plot(plotnet3v2)

N = 8
O = 2
method = 'oddevenp2'
plotnet3v2 = SU.generate_opt_masked_net(N, O, presort_in_sets=(set()), used_out_set=set(range(O)), nonsorted_out_set=None, method=method)
SU.plot(plotnet3v2)

N = 8
O = 8
method = 'oddevenp2'
plotnet3v2 = SU.generate_opt_masked_net(N, O, presort_in_sets=(set(range(4)),set([4,5])), used_out_set=set(range(N)), nonsorted_out_set=set([1,2,3,4,5,6]), method=method)
SU.plot(plotnet3v2)


###################
# baddar 22-16
###################

N = 22
O = 16
method = 'best'
plotnet3v2 = SU.generate_opt_masked_net(N, O, presort_in_sets=(set()), used_out_set=set(range(O)), nonsorted_out_set=None, method=method)
list_of_pairs = SU.to_list_of_pairs(plotnet3v2,remove_masked=True)
list_of_pairsv2 = {'method' : plotnet3v2['method'],
                          'I' : N,
                          'O' : O,
                          'pairs' : list_of_pairs}
netv2 = SU.to_stages(list_of_pairsv2)
plotnetv2 = SU.to_plotnet(netv2)
# creating plotnet3 (adding a third parameter for each comparison)
plotnet3v2 = SU.to_plotnet_triple(plotnetv2)
SU.plot(plotnet3v2)


###################
# odd 32-16
###################

N = 32
O = 16
method = 'oddevenmerge'
plotnet3v2 = SU.generate_opt_masked_net(N, O, presort_in_sets=(set()), used_out_set=set(range(O)), nonsorted_out_set=None, method=method)
list_of_pairs = SU.to_list_of_pairs(plotnet3v2,remove_masked=True)
list_of_pairsv2 = {'method' : plotnet3v2['method'],
                          'I' : N,
                          'O' : O,
                          'pairs' : list_of_pairs}
netv2 = SU.to_stages(list_of_pairsv2)
plotnetv2 = SU.to_plotnet(netv2)
# creating plotnet3 (adding a third parameter for each comparison)
plotnet3v2 = SU.to_plotnet_triple(plotnetv2)
SU.plot(plotnet3v2)
