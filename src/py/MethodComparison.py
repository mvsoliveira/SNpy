from SortingUtils import SortingUtils
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

SU = SortingUtils()

df = pd.DataFrame()

Nf = 512
step = 32

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

for I in (list(range(2,128))+list(range(128,Nf+1,1))):
    print('Generating networks with I = {i:d}.'.format(i=I))
    for cfg in cfgs:
        if cfg['iopt']:
            gI = 2**int(np.ceil(np.log2(I)))
        else:
            gI = I

        pairsv2 = SU.generate_net_pairs(N=gI, methodin=cfg['method'])

        if cfg['iopt']:
            pairsv2 = SU.opt_pairs_in(pairsv2, I, bottomup=cfg['bottomup'])

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
df =pd.read_pickle('methods.pickle')

dfc = df.set_index(['n' ,'Methods'])['c'].unstack()
dfd = df.set_index(['n' ,'Methods'])['d'].unstack()

dfc = dfc[['bitonicp2_True_False', 'bitonicp2_True_True',
       'oddevenp2_True_False',
       'oddevenp2_True_True','merge-exchange_False_None']]

dfd = dfd[['bitonicp2_True_False', 'bitonicp2_True_True',
       'oddevenp2_True_False',
       'oddevenp2_True_True','merge-exchange_False_None']]


ax = dfc.plot()
plt.ylabel('c')
plt.xticks([2]+list(range(step,Nf+1,step)))
plt.savefig('c.pdf')
plt.show()

ax = dfc.plot()
plt.ylabel('c')
plt.xticks([2]+list(range(step,Nf+1,step)))
plt.yscale('log', basey=10)
plt.savefig('clog.pdf')
plt.show()

ax = dfd.plot()
plt.xscale('log', basex=2)
plt.ylabel('d')
plt.yticks(range(0,51,10))
plt.savefig('dlog.pdf')
plt.show()

ax = dfd.plot()
plt.xticks([2]+list(range(step,Nf+1,step)))
plt.ylabel('d')
plt.yticks(range(0,51,10))
plt.savefig('d.pdf')
plt.show()

# fig.savefig('test.pdf',bbox_inches='tight')

df.to_excel('MethodComparison.xlsx')