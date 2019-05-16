import numpy as np
import matplotlib.pyplot as plt
import math as m
import random
import sys
from matplotlib.backends.backend_pdf import PdfPages

class SortingUtils:
    plot_filename_fmt = '../../out/pdf/plot_I{i:03d}_O{i:03d}.pdf'
    plot_bitonic_filename_fmt = '../../out/pdf/plot_bitonic_I{i:03d}_O{i:03d}.pdf'
    plot_masked_filename_fmt = '../../out/pdf/plot_I{i:03d}_O{o:03d}_masked.pdf'
    plot_opt_filename_fmt = '../../out/pdf/plot_I{i:03d}_O{o:03d}_D{d:03d}_opt.pdf'
    plot_dpi = 300
    cfg_fmt = '(a => {a:<3}, b => {b:<3}, p => {p:s})'
    stage_fmt = '({stage:s})'
    net_fmt = 'when {i:d} => return (\n{net:s}\n);'
    serial_net_fmt = 'when {i:d} => return {net:s};\n'

    def oddeven_merge(self, lo, hi, r):
        step = r * 2
        if step < hi - lo:
            for bar in self.oddeven_merge(lo, hi, step):
                yield bar
            for bar in self.oddeven_merge(lo + r, hi, step):
                yield bar
            for bar in [(i, i + r) for i in range(lo + r, hi - r, step)]:
                yield bar
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
            for bar in self.oddeven_merge_sort_range(lo, mid):
                yield bar
            for bar in self.oddeven_merge_sort_range(mid + 1, hi):
                yield bar
            for bar in self.oddeven_merge(lo, hi, 1):
                yield bar


    def oddeven_merge_sort(self, length):
        """ "length" is the length of the list to be sorted.
        Returns a list of pairs of indices starting with 0 """

        for bar in self.oddeven_merge_sort_range(0, length - 1):
            yield bar

    def compare_and_swap(self, x, a, b, key=lambda k:k, reverse = True):

        if reverse==False:
            expr = key(x[a]) > key(x[b])
        else:
            expr = key(x[a]) <= key(x[b])

        if expr:
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

    def plot(self, plotnet, stages_i, filename, I):

        color = ['black', 'red', 'blue', 'magenta', 'green']
        linestyle = ['dotted', 'dashed']

        # the first line delimiter is always 0 as cannot be a register
        stages = stages_i.copy()
        stages.insert(0,0)

        fig, ax = plt.subplots(figsize=(I,I))
        plt.ylim(I+1,-2)
        self.set_plot_length(plotnet)
        points = np.ones(self.plot_length)
        # plotting horizontal lines and text
        for y in range(I):
            ax.plot(y * points, color='black')
            ax.text(0,y-self.number_margin,'{y:03d}'.format(y=y),   horizontalalignment='left')
            ax.text(self.plot_length-1, y-self.number_margin, '{y:03d}'.format(y=y), horizontalalignment='right')

        # plotting pairs and stage delimeters
        x = self.plot_margin
        for i,s in enumerate(plotnet):
            x -= self.plot_stagesp / 2
            # plotting stage line delimeter
            ax.plot((x, x), (-1, I), linestyle=linestyle[stages[i]], color='gray')
            # plotting stage number
            curr_stage_half_spacing = ((len(s) - 1) * self.plot_substagesp + self.plot_stagesp) / 2
            x += curr_stage_half_spacing
            ax.text(x, -1, '{y:d}'.format(y=i), horizontalalignment='center', verticalalignment='top')
            ax.text(x, I, '{y:d}'.format(y=i), horizontalalignment='center', verticalalignment='baseline')
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
        ax.plot((x, x), (-1, I), linestyle=linestyle[stages[-1]], color='gray')
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

    def mask_net_in(self,plotnet3,minin, maxin):
        for stage in plotnet3:
            for substage in stage:
                for pair in substage:
                    if (minin <= pair[0] <= maxin) or (minin <= pair[1] <= maxin):
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


    def generate_masked_oddevenmerge(self, N, O, presort_in_sets=(set()), used_out_set=None, nonsorted_out_set=set()):
        # finding next power2 size
        Nceil = 2 ** int(np.ceil(np.log2(N)))
        # getting list of pairs
        list_of_pairs = list(self.oddeven_merge_sort(Nceil))
        # finding the stages
        net = self.to_stages(list_of_pairs)
        # creating plotnet object (adding substages)
        plotnet = self.to_plotnet(net)
        # creating plotnet3 (adding a third parameter for each comparison)
        plotnet3 = self.to_plotnet_triple(plotnet)
        # masking unused inputs
        plotnet3_m = self.mask_net_in(plotnet3, N, Nceil-1)
        # masking comparators from presorted inputs
        for iset in presort_in_sets:
            self.net_presort_opt(plotnet3_m, iset)
        # optimizing away unused outputs
        if used_out_set == None:
            used_out_set = set(range(N))
        self.net_unused_out_opt(plotnet3_m, used_out_set)
        # optimizing away comparison for outputs which does not need do be sorted
        self.net_nonsorted_out_opt(plotnet3_m, nonsorted_out_set)

        return plotnet3_m

    def net_presort_opt(self, plotnet3, iset):
        for stage in plotnet3:
            for substage in stage:
                for cmp in substage:
                    # if this comparison was not already optimized away
                    if cmp[2] == 0:
                        # if the two members of the comparison belongs to the presorted set
                        if len(iset.intersection(cmp[:2])) == 2:
                            # optimize them away
                            cmp[2] = 2
                        # if one of members intersects with an input outside the set, do not look further anymore
                        elif len(iset.intersection(cmp[:2])) == 1:
                            return True
                        # if else, just continues ;)

    def to_list_of_pairs(self, plotnet3):
        list_of_pairs = []
        for stage in plotnet3:
            for substage in stage:
                for cmp in substage:
                    # if this comparison was not optimized away
                    if cmp[2] == 0:
                        list_of_pairs.append(cmp[:2])
        return list_of_pairs

    def net_unused_out_opt(self, plotnet3, used_out_set_i):
        # copying set to preserve it
        used_out_set = used_out_set_i.copy()
        for stage in reversed(plotnet3):
            for substage in reversed(stage):
                for cmp in reversed(substage):
                    # if this comparison was not already optimized away
                    if cmp[2] == 0:
                        # if none of two members of the comparison belongs to the used out set
                        if len(used_out_set.intersection(cmp[:2])) == 0:
                            # optimize them away
                            cmp[2] = 3
                        # if one used output intersects with an unused output, threat this output as an used one
                        elif len(used_out_set.intersection(cmp[:2])) == 1:
                            used_out_set.update(cmp[:2])
                        # if else, just continues ;)

    def net_nonsorted_out_opt(self, plotnet3, nonsorted_out_set_i):
        # copying set to preserve it
        nonsorted_out_set = nonsorted_out_set_i.copy()
        for stage in reversed(plotnet3):
            for substage in reversed(stage):
                for cmp in reversed(substage):
                    # if this comparison was not already optimized away
                    if cmp[2] == 0:
                        # if both of two members of the comparison belongs to the non sorted out set
                        if len(nonsorted_out_set.intersection(cmp[:2])) == 2:
                            # optimize them away
                            cmp[2] = 4
                        # if one unsorted output intersects with another output, discard this output from the unsorted set
                        elif len(nonsorted_out_set.intersection(cmp[:2])) == 1:
                            nonsorted_out_set.discard(cmp[0])
                            nonsorted_out_set.discard(cmp[1])
                        # if else, just continues ;)

    def get_muctpi_presort_in_sets(self, I):
        rpc = [2]
        tgc = [4]

        if   I==352:
            all = 32 * rpc + 72 * tgc
        elif I==88:
            all = 32 * rpc + 6 * tgc
        elif I==64:
            cand = [16]
            all = 4 * cand
        else:
            all=[]

        presort_in_sets = []
        i = 0
        for cand_sec in all:
            presort_in_sets.append(set(range(i, i + cand_sec)))
            i += cand_sec
        return presort_in_sets



    def get_muctpi_opt_sets(self, I):
        O = 16
        presort_in_sets = self.get_muctpi_presort_in_sets(I)
        #presort_in_sets = [set()]
        used_out_set = set(range(O))
        #nonsorted_out_set = set(range(64))
        nonsorted_out_set = set()
        return (I, O, presort_in_sets, used_out_set, nonsorted_out_set)



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

    def generate_reduced_bitonic_plot(self, N):
        filename = self.plot_bitonic_filename_fmt.format(i=N, o=N)
        list_of_comparisons = self.get_bitonic_list_of_comparisons(N)
        net = self.to_stages(list_of_comparisons)
        stages = self.get_stages_cfg(len(net))
        print('Number of stages for reduced net N={N:03d} = {stages:d}'.format(N=N,stages=len(net)))
        plotnet = self.to_plotnet(net)
        plotnet3 = self.to_plotnet_triple(plotnet)
        self.plot(plotnet3, stages, filename, N)


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

    def generate_csn_sel_pkg(self, net_sets, gen_plots = False, validation = -1):
        file = open('../../out/vhd/csn_sel_pkg_ref', 'w')
        (I, O, presort_in_sets, used_out_set, nonsorted_out_set) = net_sets
        [list_of_pairs, net] = self.get_muctpi_sel_net(gen_plots, net_sets)

        # validation
        if validation > 0:
            print('Validating sorting network I={I:d}'.format(I=I))
            print('Pre-sorting input set: {P:s}'.format(P=str(presort_in_sets)))
            print('Used output range len: {O:d} set: {U:s}'.format(O=O, U=str(used_out_set)))
            print('Non-sorted output range set: {S:s}'.format(S=str(nonsorted_out_set)))

            for v in range(validation):
                # Getting random data
                data = [random.randint(0,2**30) for _ in range(I)]
                # Sorting random data
                py_sorted = sorted(data, reverse = True)
                # Pre sorting inputs for required sets
                if presort_in_sets != [set()]:
                    for s in presort_in_sets:
                        data[min(s):max(s) + 1] = sorted(data[min(s):max(s) + 1], reverse = True)
                # Sorting data using the list of pairs
                for i in list_of_pairs: self.compare_and_swap(data, *i, reverse = True)
                # if there is no nonsorted outputs the output data has to be sorted in the used output range
                if nonsorted_out_set == set():
                    cmp = data[0:O-1] == py_sorted[0:O-1]
                else:
                # else the output data has to contain the same data but not sorted
                    cmp = sorted(data[0:O - 1], reverse = True) == py_sorted[0:O - 1]
                # checking the comparison value
                if cmp:
                    print('Validation iteration {v:04d} OK'.format(v=v))
                else:
                    print('Error: Validation iteration {v:04d}'.format(v=v))
                    print('python sorted:', py_sorted)
                    print('net sorted:', data)
                    sys.exit()

        # Generating vhdl package
        cfg_stage_str = []
        reg = ['False', 'True ']
        for i, stage in enumerate(net):
            cfg_stage = [self.cfg_fmt.format(a=str(p[0]), b=str(p[1]), p='False') for p in stage]
            missing = self.find_missing_pairs(stage, I)
            cfg_stage += [self.cfg_fmt.format(a=str(p[0]), b=str(p[1]), p='True ') for p in missing]
            cfg_stage_str.append(self.stage_fmt.format(stage=', '.join(cfg_stage)))

        file.write(self.net_fmt.format(i=I, net=',\n'.join(cfg_stage_str)))

        file.close()

    def generate_csn_serial_pkg(self, values):
        file = open('../../out/vhd/csn_serial_pkg_ref', 'w')
        for i, N in enumerate(values):
            list_of_pairs = self.generate_oddevenmerge_list_of_pairs(N)
            cfg_stage_str = []
            cfg_stage = [self.cfg_fmt.format(a=str(p[0]), b=str(p[1]), p='False') for p in list_of_pairs]
            cfg_stage_str.append(self.stage_fmt.format(stage=', '.join(cfg_stage)))
            file.write(self.serial_net_fmt.format(i=N, net=',\n'.join(cfg_stage_str)))

    def get_stages_cfg(self, n_stages, n_regs):
        reg = ['False', 'True']
        stages = self.distribute_equally_spaced(1, 0, n_regs+1, n_stages+1)[1:]
        print('when {s:d} =>'.format(s=n_regs))
        print('-- Registered stages configuration')
        print('-- num -> | {a:s}|;'.format(a=', '.join(['{i:>5d}'.format(i=i) for i in range(len(stages))])))
        print('return    ( {a:s});'.format(a=', '.join(['{s:>5s}'.format(s=reg[s]) for s in stages])))
        print('-- total number of registered stages: {n:d}.'.format(n=sum(stages)))
        return stages

    def get_muctpi_sel_net(self, gen_plots, net_sets):
        plotnet3 = self.generate_masked_oddevenmerge(*net_sets)
        stages = [0] * len(plotnet3)
        I = net_sets[0]
        O = net_sets[1]
        Iceil = 2 ** int(np.ceil(np.log2(I)))
        if gen_plots:
            filename = self.plot_masked_filename_fmt.format(i=I, o=O)
            self.plot(plotnet3, stages, filename, Iceil)
        list_of_pairs = self.to_list_of_pairs(plotnet3)
        # finding the stages
        net = self.to_stages(list_of_pairs)


        if gen_plots:
            # creating plotnet object (adding substages)
            plotnet = self.to_plotnet(net)
            # creating plotnet3 (adding a third parameter for each comparison)
            plotnet3 = self.to_plotnet_triple(plotnet)
            n_stages = len(plotnet3)
            for i in range(1, n_stages + 1):
                stages = s.get_stages_cfg(n_stages, i)
                filename = self.plot_opt_filename_fmt.format(i=I, o=O, d=i)
                self.plot(plotnet3, stages, filename, I)
        return [list_of_pairs, net]


    def get_bitonic_list_of_comparisons(self, N):
        def gen_bitonic_sortnet(n, start):
            def copy_net(net, dy, dt=0):
                return [[v[0] + dy, v[1] + dy, v[2] + dt] for v in net]

            def gen_halfclean(n, start):
                return [[i, i + n // 2, start + i] for i in range(n // 2)]

            def gen_bitonic(n, start):
                if n == 2:
                    return gen_halfclean(n, start)
                else:
                    L = gen_halfclean(n, start)
                    R1 = gen_bitonic(n // 2, start + n // 2)
                    R2 = copy_net(R1, n // 2)
                    return L + R1 + R2

            def gen_right(n, start):
                L = [[i, n - i - 1, start + i] for i in range(n // 2)]
                R1 = gen_bitonic(n // 2, start + n // 2)
                R2 = copy_net(R1, n // 2)
                return L + R1 + R2

            if n == 2:
                return gen_halfclean(n, start)
            else:
                L1 = gen_bitonic_sortnet(n // 2, 0)
                maxt = max([v[2] for v in L1])
                L1 = copy_net(L1, 0, start - 1 - maxt - 1)
                L2 = copy_net(L1, n // 2)
                R = gen_right(n, start)
                return L1 + L2 + R

        def get_bitonic_sort(n):
            net = gen_bitonic_sortnet(n, 0)
            mint = min([v[2] for v in net])
            for v in net:
                v[2] -= mint
            R = {}
            for v in net:
                if v[2] not in R:
                    R[v[2]] = []
                R[v[2]].append((v[0], v[1]))
            return R

        data = get_bitonic_sort(N)
        list_of_comparisons = []
        for key, d in data.items():
            #print(key, d)
            list_of_comparisons.extend(d)
        return list_of_comparisons

    def keep_average_int(self, inc,hist):
        avg = np.mean(hist)

        if avg > inc:
            int_inc = np.floor(inc)
        else:
            int_inc = np.ceil(inc)

        hist.append(int_inc)
        return int(int_inc)

    def distribute_equally_spaced(self, item, remaining, n, length):
        #having always the item in the borders
        if length < n:
            return -1
        else:
            data = [item] + [remaining]*(length-2) + [item]
            if n > 2:
                step = (length-2+1)/(n-2+1)
                step_hist = [np.round(step)]
                i = 0
                for j in range(n-2):
                    i += self.keep_average_int(step,step_hist)
                    data[i] = item

            return data



if __name__ == "__main__":
    s = SortingUtils()

    #net_sets = (I, O, presort_in_sets, used_out_set, nonsorted_out_set) = s.get_muctpi_sort_opt_sets(352)
    I = 64
    net_sets = (I, O, presort_in_sets, used_out_set, nonsorted_out_set) = s.get_muctpi_opt_sets(I)


    s.generate_csn_sel_pkg(net_sets, gen_plots = True, validation = 2**10)





