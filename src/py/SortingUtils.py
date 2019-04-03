import numpy as np
import matplotlib.pyplot as plt

class SortingUtils:
    def oddeven_merge(self, lo, hi, r):
        step = r * 2
        if step < hi - lo:
            self.stage += 1
            yield from self.oddeven_merge(lo, hi, step)
            yield from self.oddeven_merge(lo + r, hi, step)
            self.stage += 1
            yield from [(i, i + r) for i in range(lo + r, hi - r, step)]
        else:
            yield (lo, lo + r)


    def oddeven_merge_sort_range(self, lo, hi):
        """ sort the part of x with indices between lo and hi.

        Note: endpoints (lo and hi) are included.
        """
        if (hi - lo) >= 1:
            # if there is more than one element, split the input
            # down the middle and first sort the first and second
            # half, followed by merging them.
            mid = lo + ((hi - lo) // 2)
            yield from self.oddeven_merge_sort_range(lo, mid)
            yield from self.oddeven_merge_sort_range(mid + 1, hi)
            yield from self.oddeven_merge(lo, hi, 1)


    def oddeven_merge_sort(self, length):
        """ "length" is the length of the list to be sorted.
        Returns a list of pairs of indices starting with 0 """
        self.stage = 0
        yield from self.oddeven_merge_sort_range(0, length - 1)

    def compare_and_swap(self, x, a, b):
        if x[a] > x[b]:
            x[a], x[b] = x[b], x[a]

    def set_plot_length(self,net):
        self.margin = 8
        self.stagesp = 4
        self.substagesp = 1
        self.length = 2*self.margin+1
        self.length += (len(net)-1) * self.stagesp
        for s in net:
            self.length += (len(s)-1) * self.substagesp

    def plot(self, plotnet, filename, N):

        fig, ax = plt.subplots(figsize=(N,N))
        plt.ylim(N+1,-2)
        self.set_plot_length(plotnet)
        points = np.ones(self.length)
        # plotting horizontal lines
        for y in range(N):
            ax.plot(y * points, color='black')

        x = self.margin
        for s in plotnet:
            for sub in s:
                for pair in sub:
                    ax.plot((x,x),pair,color='black', marker='o')
                x += self.substagesp
            x += self.stagesp - self.substagesp

        #ax.margins(0.2)
        ax.set_axis_off()
        plt.savefig(filename, dpi=40, bbox_inches='tight')
        #plt.show()
        plt.close()

    def flatten(self, l):
        flatten_f = lambda l: [item for sublist in l for item in sublist]
        return flatten_f(l)

    def to_stages(self,list_of_pairs):
        net = [[]]
        for pair in list_of_pairs:
            done = False
            s = 0
            while not done:
                present = False
                futurepresent = False
                if len(net[s]) > 0:
                    for p in net[s]:
                        if (pair[0] in p) or (pair[1] in p):
                            present = True

                if not present:
                    ## Is it present in the future?
                    future_pairs = self.flatten(net[s+1:])
                    for p in future_pairs:
                        if (pair[0] in p) or (pair[1] in p):
                            futurepresent = True

                if (not present) and (not futurepresent):
                    net[s].append(pair)
                    done = True
                else:
                    if s+2 > len(net):
                        net.append([pair])
                        done = True
                    else:
                        s += 1
        return net


    def to_plotnet(self,net):
        # single substages solution
        #net = [[[p] for p in item] for item in net]
        # avoiding overlaps
        plotnet=[]
        for stage in net:
            substages = [[]]
            substage_ranges = [[]]
            for pair in stage:
                done = False
                s = 0
                prange = [i for i in range(pair[0], pair[1] + 1)]
                while not done:
                    if not set(prange).intersection(set(substage_ranges[s])):
                        substages[s].append(pair)
                        for i in range(pair[0], pair[1] + 1):
                            substage_ranges[s].append(i)
                        done = True
                    elif s + 2 > len(substages):
                        substages.append([pair])
                        substage_ranges.append([i for i in range(pair[0], pair[1] + 1)])
                        done = True
                    else:
                        s += 1
            plotnet.append(substages)
        return plotnet


    def print_plotnet(self,plotnet):
        for (i,s) in enumerate(plotnet):
            for (j,sub) in enumerate(s):
                print('Stage ({i:04d},{j:04d}) : {sub:s}'.format(i=i, j=j, sub=str(sub)))





s = SortingUtils()
for i in range(9,10):
    N = 2**i
    filename = 'plot_I{i:03d}_O{i:03d}'.format(i=N,o=N)
    list_of_pairs = list(s.oddeven_merge_sort(N))
    net = s.to_stages(list_of_pairs)
    plotnet = s.to_plotnet(net)
    s.plot(plotnet, filename, N)
















#for i in s.oddeven_merge_sort(16):
#    print(i)

