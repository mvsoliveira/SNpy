import numpy as np
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages

class SortingUtils:
    plot_filename_fmt = '../../out/pdf/plot_I{i:03d}_O{i:03d}.pdf'
    plot_masked_filename_fmt = '../../out/pdf/plot_I{i:03d}_O{i:03d}_masked.pdf'
    plot_dpi = 300
    cfg_fmt = '(a => {a:<3}, b => {b:<3}, p => {p:s}, o => False, r => False)'
    stage_fmt = '({stage:s})'
    net_fmt = 'when {i:d} => return (\n{net:s}\n);'
    serial_net_fmt = 'when {i:d} => return {net:s};\n'

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
        self.plot_margin = 8
        self.number_margin = 0.05
        self.plot_stagesp = 4
        self.plot_substagesp = 1
        self.plot_length = 2 * self.plot_margin + 1
        self.plot_length += (len(net) - 1) * self.plot_stagesp
        for s in net:
            self.plot_length += (len(s) - 1) * self.plot_substagesp

    def plot(self, plotnet, filename, N):

        color = ['black', 'red']

        fig, ax = plt.subplots(figsize=(N,N))
        plt.ylim(N+1,-2)
        self.set_plot_length(plotnet)
        points = np.ones(self.plot_length)
        # plotting horizontal lines and text
        for y in range(N):
            ax.plot(y * points, color='black')
            ax.text(0,y-self.number_margin,'{y:03d}'.format(y=y),   horizontalalignment='left')
            ax.text(self.plot_length-1, y-self.number_margin, '{y:03d}'.format(y=y), horizontalalignment='right')

        # plotting pairs and stage delimeters
        x = self.plot_margin
        for i,s in enumerate(plotnet):
            x -= self.plot_stagesp / 2
            # plotting stage line delimeter
            ax.plot((x, x), (-1, N), linestyle='dashed', color='gray')
            # plotting stage number
            curr_stage_half_spacing = ((len(s) - 1) * self.plot_substagesp + self.plot_stagesp) / 2
            x += curr_stage_half_spacing
            ax.text(x, -1, '{y:d}'.format(y=i), horizontalalignment='center', verticalalignment='top')
            ax.text(x, N, '{y:d}'.format(y=i), horizontalalignment='center', verticalalignment='baseline')
            x -= curr_stage_half_spacing
            x += self.plot_stagesp / 2
            # plotting substages
            for sub in s:
                for pair in sub:
                    ax.plot((x,x),pair[:2],color=color[pair[2]], marker='o')
                x += self.plot_substagesp
            x += self.plot_stagesp - self.plot_substagesp
        # plotting last stage delimeter
        x -= self.plot_stagesp / 2
        ax.plot((x, x), (-1, N), linestyle='dashed', color='gray')
        #ax.margins(0.2)
        ax.set_axis_off()
        # saving picture
        plt.savefig(filename, format='pdf', bbox_inches='tight')
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

    def to_plotnet_triple(self,plotnet):
        return [[[list(pair) + [0] for pair in substage] for substage in stage] for stage in plotnet]

    def mask_net_in(self,plotnet3,maxin):
        for stage in plotnet3:
            for substage in stage:
                for pair in substage:
                    if (pair[0] > maxin) or (pair[1] > maxin):
                        pair[2] = 1
        return plotnet3

    def prum_masked_list(self, plotnet3):
        return [[[pair for pair in substage if pair[2] == 0] for substage in stage] for stage in plotnet3]

    def print_plotnet(self,plotnet):
        for (i,s) in enumerate(plotnet):
            for (j,sub) in enumerate(s):
                print('Stage ({i:04d},{j:04d}) : {sub:s}'.format(i=i, j=j, sub=str(sub)))

    def generate_oddevenmerge_plots(self,values):
        for i, N in enumerate(values):
            self.generate_reduced_oddevenmerge_plot(N)


    def generate_masked_oddevenmerge_plot(self, N):
        filename = self.plot_masked_filename_fmt.format(i=N, o=N)
        Nceil = 2 ** int(np.ceil(np.log2(N)))
        list_of_pairs = list(self.oddeven_merge_sort(Nceil))
        net = self.to_stages(list_of_pairs)
        plotnet = self.to_plotnet(net)
        plotnet3 = self.to_plotnet_triple(plotnet)
        plotnet3_m = self.mask_net_in(plotnet3, N - 1)
        self.plot(plotnet3_m, filename, Nceil)

    def generate_reduced_oddevenmerge(self, N):
        reduced_pairs = self.generate_oddevenmerge_list_of_pairs(N)
        net = self.to_stages(reduced_pairs)
        return net

    def generate_oddevenmerge_list_of_pairs(self, N):
        Nceil = 2 ** int(np.ceil(np.log2(N)))
        list_of_pairs = list(self.oddeven_merge_sort(Nceil))
        reduced_pairs = [p for p in list_of_pairs if not (p[0] > N - 1 or p[1] > N - 1)]
        return reduced_pairs



    def generate_reduced_oddevenmerge_plot(self, N):
        filename = self.plot_filename_fmt.format(i=N, o=N)
        net = self.generate_reduced_oddevenmerge(N)
        print('Number of stages for reduced net N={N:03d} = {stages:d}'.format(N=N,stages=len(net)))
        plotnet = self.to_plotnet(net)
        plotnet3 = self.to_plotnet_triple(plotnet)
        self.plot(plotnet3, filename, N)


    def in_list(self, list_of_lists, item):
        for list_ in list_of_lists:
            if item in list_:
                return True
        return False

    def find_missing(self, s, I):
        values = range(0, I, 1)
        missing = []
        for v in values:
            if not self.in_list(s, v):
                missing.append(v)
        return missing

    def find_missing_pairs(self, stages, I):
        s = self.find_missing(stages, I)
        pairs = []
        while s:
            pairs.append([s.pop(0), s.pop()])
        return pairs

    def generate_csn_pkg(self, values):
        file = open('../../out/vhd/csn_pkg_ref', 'w')
        for i, N in enumerate(values):
            net = self.generate_reduced_oddevenmerge(N)
            cfg_stage_str = []
            for stage in net:
                cfg_stage = [self.cfg_fmt.format(a=str(p[0]), b=str(p[1]), p='False') for p in stage]
                missing = self.find_missing_pairs(stage, N)
                cfg_stage += [self.cfg_fmt.format(a=str(p[0]), b=str(p[1]), p='True ') for p in missing]
                cfg_stage_str.append(self.stage_fmt.format(stage=', '.join(cfg_stage)))

            file.write(self.net_fmt.format(i=N, net=',\n'.join(cfg_stage_str)))

        file.close()

    def generate_csn_serial_pkg(self, values):
        file = open('../../out/vhd/csn_serial_pkg_ref', 'w')
        for i, N in enumerate(values):
            list_of_pairs = self.generate_oddevenmerge_list_of_pairs(N)
            cfg_stage_str = []
            cfg_stage = [self.cfg_fmt.format(a=str(p[0]), b=str(p[1]), p='False') for p in list_of_pairs]
            cfg_stage_str.append(self.stage_fmt.format(stage=', '.join(cfg_stage)))
            file.write(self.serial_net_fmt.format(i=N, net=',\n'.join(cfg_stage_str)))







if __name__ == "__main__":
    s = SortingUtils()
    s.generate_csn_serial_pkg([2 ** i for i in range(1, 10)])
    #s.generate_oddevenmerge_plots([2 ** i for i in range(1, 10)])
    #s.generate_oddevenmerge_plots([352])
    #s.generate_masked_oddevenmerge_plot(352)




