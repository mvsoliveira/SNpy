import numpy as np

# def even_odd_merge_s(n):
#     # number of comparators for odd-even-merge sorting network
#     if n ==2:
#         return 1
#     else:
#         return 2*even_odd_merge_s(n/2) + even_odd_merge_m(n)
#
# def even_odd_merge_m(n):
#     # number of comparators for a merge sorting network
#     if n ==2:
#         return 1
#     else:
#         return 2*even_odd_merge_m(n/2) + n/2 -1

def even_odd_merge_s(n):
    # number of comparators for a power of 2 odd-even-merge sorting network
    t = np.log2(n)
    return int((t**2-t+4)*2**(t-2)-1)


def even_odd_merge_d(n):
    a = 1+np.ceil(np.log2(n))
    b = 2
    delay=np.math.factorial(a)/(np.math.factorial(a-b)*np.math.factorial(b))
    return int(delay)


# def bitonic_s(n):
#     # for a bitonic sequence
#     if n ==2:
#         return 1
#     else:
#         return bitonic_s(np.ceil(n/2)) + bitonic_s(np.floor(n/2)) + np.floor(n/2)

def bitonic_s(n):
    # number of comparators for a power of 2 bitonic sorter for a bitonic sequence
    if n ==2:
        return 1
    else:
        return int(np.log2(n)*2**(np.log2(n)-1))

def bitonic_d(n):
    # number of stages for a power of 2 bitonic sorter for a bitonic sequence
    return int(np.ceil(np.log2(n)))



def total_bitonic_s(n):
    # total number for a non bitonic sequence
    i = n
    total = 0
    while i >=2:
        total += (n/i)*bitonic_s(i)
        i /=2
    return int(total)

def total_bitonic_d(n):
    # total number for a non bitonic sequence
    i = n
    total = 0
    while i >=2:
        total += bitonic_d(i)
        i /=2
    return int(total)

def C(m,n):
    if m*n <= 1:
        return m*n
    else:
        return C(np.ceil(m/2.0),np.ceil(n/2.0)) + C(np.floor(m/2.0),np.floor(n/2.0)) + np.floor((m+n-1)/2.0)

def cM(n):
    if n < 2:
        return 0
    else:
        return int(cM(np.ceil(n/2.0)) + cM(np.floor(n/2.0)) + C(np.ceil(n/2.0),np.floor(n/2.0)))

def cB(n):
    if n < 2:
        return 0
    else:
        return cB(np.ceil(n/2.0)) + cB(np.floor(n/2.0)) + np.floor(n/2.0)

def d(n):
    return even_odd_merge_d(n)


if __name__=='__main__':

    for i in range(2,20):
        print('Odd-even-Merging: c({n:d}) = {s:f} ; d({n:d}) = {d:d} '.format(n=i, s=cM(i),
                                                                              d=d(i)))
        print('Bitonic         : c({n:d}) = {s:f} ; d({n:d}) = {d:d} '.format(n=i, s=cB(i),
                                                                              d=d(i)))


    for i in range(2,10):
        print('Odd-even-Merging: S({n:d}) = {s:d} ; D({n:d}) = {d:d} '.format(n=2**i,s=even_odd_merge_s(2**i),d=even_odd_merge_d(2**i)))
        print('Bitonic         : S({n:d}) = {s:d} ; D({n:d}) = {d:d} '.format(n=2 ** i, s=total_bitonic_s(2 ** i),d=total_bitonic_d(2 ** i)))
