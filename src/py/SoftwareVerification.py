from SortingUtils import SortingUtils
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

SU = SortingUtils()

pairsv2 = SU.generate_net_pairs(N=22, methodin='best')

pairs = pairsv2['pairs']

data = []

for i in range(22):
    data.append({
        'pt': i%2,
        'count' : i
    })

print(data)
for i in pairs: SU.compare_and_swap(data, *i[:2], key = lambda k: k['pt'],reverse=True)



print(data)