import math as m

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
    t = m.log(n,2)
    return int((t**2-t+4)*2**(t-2)-1)


def even_odd_merge_d(n):
    a = 1+m.ceil(m.log(n,2))
    b = 2
    d=m.factorial(a)/(m.factorial(a-b)*m.factorial(b))
    return d


# def bitonic_s(n):
#     # for a bitonic sequence
#     if n ==2:
#         return 1
#     else:
#         return bitonic_s(m.ceil(n/2)) + bitonic_s(m.floor(n/2)) + m.floor(n/2)

def bitonic_s(n):
    # number of comparators for a power of 2 bitonic sorter for a bitonic sequence
    if n ==2:
        return 1
    else:
        return int(m.log(n,2)*2**(m.log(n,2)-1))

def bitonic_d(n):
    # number of stages for a power of 2 bitonic sorter for a bitonic sequence
    return int(m.ceil(m.log(n,2)))



def total_bitonic_s(n):
    # total number for a non bitonic sequence
    i = n
    total = 0
    while i >=2:
        total += (n/i)*bitonic_s(i)
        i /=2
    return total

def total_bitonic_d(n):
    # total number for a non bitonic sequence
    i = n
    total = 0
    while i >=2:
        total += bitonic_d(i)
        i /=2
    return total

for i in range(2,10):
    print 'Odd-even-Merging: S({n:d}) = {s:d} ; D({n:d}) = {d:d} '.format(n=2**i,s=even_odd_merge_s(2**i),d=even_odd_merge_d(2**i))
    print 'Bitonic         : S({n:d}) = {s:d} ; D({n:d}) = {d:d} '.format(n=2 ** i, s=total_bitonic_s(2 ** i),d=total_bitonic_d(2 ** i))
