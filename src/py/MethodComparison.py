from SortingUtils import SortingUtils
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from gen_size_depth import *

SU = SortingUtils()

generate_df = True
Nf = 512
plotstep = 32 #for plot only
step = 1 # for points after 128
nrange = (list(range(2,128))+list(range(128,Nf+1,step)))

if generate_df:


    df = pd.DataFrame()

    cfgs = []

    cfgs.append({'method' : 'oddevenp2',
                 'iopt' : True,
                 'bottomup' : True})

    cfgs.append({'method' : 'oddevenp2',
                 'iopt' : True,
                 'bottomup' : False})

    cfgs.append({'method' : 'bitonicp2',
                 'iopt' : True,
                 'bottomup' : True})

    cfgs.append({'method' : 'bitonicp2',
                 'iopt' : True,
                 'bottomup' : False})

    cfgs.append({'method' : 'merge-exchange',
                 'iopt' : False,
                 'bottomup' : None})

    for I in nrange:
        print('Generating networks with I = {i:d}.'.format(i=I))
        for cfg in cfgs:
            if cfg['iopt']:
                gI = 2**int(np.ceil(np.log2(I)))
            else:
                gI = I

            pairsv2 = SU.generate_net_pairs(N=gI, methodin=cfg['method'])

            if cfg['iopt']:
                pairsv2 = SU.opt_pairs_in(pairsv2, I, bottomup=cfg['bottomup'],validation=False)

            netv2 = SU.to_stages(pairsv2)

            c = len(pairsv2['pairs'])
            d = len(netv2['net'])
            df = df.append({'n' : I,
                            'gI' : gI,
                            'method' : cfg['method'],
                            'iopt' : cfg['iopt'],
                            'bottomup': cfg['bottomup'],
                            'Methods' : '{m:s}_{i:s}_{b:s}'.format(m=cfg['method'],i=str(cfg['iopt']),b=str(cfg['bottomup'])),
                            'c' : int(c),
                            'd' : int(d),
                            },ignore_index=True)

    df.to_pickle('methods.pickle')


df = pd.read_pickle('methods.pickle')

for n in range(2,Nf+1):
    df = df.append({'n': n,
                'gI': n,
                'method': 'Knuth equation',
                'iopt': None,
                'bottomup': None,
                'Methods': 'Knuth equation',
                'c': cM(n),
                'd': None,
                }, ignore_index=True)

df = df.replace('bitonicp2_True_True', 'Bitonic mergesort optimization A')
df = df.replace('bitonicp2_True_False', 'Bitonic mergesort optimization B')
df = df.replace('oddevenp2_True_True', 'Odd-even mergesort optimization A')
df = df.replace('oddevenp2_True_False', 'Odd-even mergesort optimization B')
df = df.replace('merge-exchange_False_None', 'Merge-exchange sorting')
df.columns = ['Sorting methods', 'bottomup', 'c', 'd', 'gI', 'iopt', 'method', 'n']

dfc = df.set_index(['n' ,'Sorting methods'])['c'].unstack()
dfd = df.set_index(['n' ,'Sorting methods'])['d'].unstack()

dfe = dfc[['Merge-exchange sorting', 'Knuth equation', 'Odd-even mergesort optimization A']]
dfc = dfc[['Odd-even mergesort optimization A', 'Odd-even mergesort optimization B', 'Bitonic mergesort optimization A', 'Bitonic mergesort optimization B', 'Merge-exchange sorting']]
dfd = dfd[['Odd-even mergesort optimization A', 'Odd-even mergesort optimization B', 'Bitonic mergesort optimization A', 'Bitonic mergesort optimization B', 'Merge-exchange sorting']]


ax = dfc.plot()
plt.ylabel('c')
plt.xticks([2]+list(range(plotstep,Nf+1,plotstep)))
plt.savefig('c.pdf', bbox_inches='tight')
plt.show()

ax = dfe.plot()
plt.ylabel('c')
plt.xticks([2]+list(range(plotstep,Nf+1,plotstep)))
plt.savefig('e.pdf', bbox_inches='tight')
plt.show()

ax = dfc.plot()
plt.ylabel('c')
plt.xscale('log', basex=2)
plt.yscale('log', basey=10)
plt.xticks([2**n for n in range(1,10)])
plt.savefig('clog.pdf', bbox_inches='tight')
plt.show()

ax = dfe.plot()
plt.ylabel('c')
plt.xscale('log', basex=2)
plt.yscale('log', basey=10)
plt.xticks([2**n for n in range(1,10)])
plt.savefig('elog.pdf', bbox_inches='tight')
plt.show()

ax = dfd.plot()
plt.xscale('log', basex=2)
plt.ylabel('d')
plt.yticks(range(0,51,10))
plt.xticks([2**n for n in range(1,10)])
plt.savefig('dlog.pdf', bbox_inches='tight')
plt.show()

ax = dfd.plot()
plt.xticks([2]+list(range(plotstep,Nf+1,plotstep)))
plt.ylabel('d')
plt.yticks(range(0,51,10))
plt.savefig('d.pdf', bbox_inches='tight')
plt.show()

# fig.savefig('test.pdf',bbox_inches='tight')

df.to_excel('MethodComparison.xlsx')