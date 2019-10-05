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
