import pandas as pd

# comparison exchange function
def compare_and_swap(x, a, b, key=lambda k: k, reverse=True):
    if reverse == False:
        expr = key(x[a]) >= key(x[b])
    else:
        expr = key(x[a]) <= key(x[b])

    if expr:
        x[a], x[b] = x[b], x[a]

# reading network
df = pd.read_pickle('../../out/pickle/I352O016_alhajbaddar22_R_16_oddevenmerge_R_16.pickle')
[pairs, net] = [df['pairs'][0], df['net'][0]]

# creating input data
data = []
for i in range(352):
    data.append({
        'pt': i%2,
        'roi' : i
    })

# sorting using the network
for i in pairs: compare_and_swap(data, *i[:2], key = lambda k: k['pt'],reverse=True)

# print the result
print(data)