import cocotb
from cocotb.triggers import RisingEdge, Timer, ReadOnly
from cocotb.clock import Clock
from cocotb.result import TestFailure, TestSuccess
from cocotb.regression import TestFactory
import random
import os
from sys import path
path.append(os.getcwd() + "/../../../src/py")
from SortingModel import SortingModel

import copy




class MyTB(object):

    def __init__(self, dut, SM, n, ratio):
        self.dut = dut
        self.n = n
        self.I = self.dut.I.value
        self.O = self.dut.O.value
        #self.delay = self.dut.delay.value
        self.val_cand_frac_range = ratio
        self.ptlen = self.dut.muon_i[0].pt.value.n_bits
        self.idxlen = self.dut.muon_i[0].idx.value.n_bits
        self.roilen = self.dut.muon_i[0].roi.value.n_bits
        self.flagslen = self.dut.muon_i[0].flags.value.n_bits
        self.SM = SM
        self.dut._log.info('#' * 50)
        self.dut._log.info("Testing muon sorter with the following settings:")
        self.dut._log.info('Simulation length: {len: d}'.format(len=self.n))
        self.dut._log.info('Number of candidates: input: {num_in:d} | output: {num_out:d}'.format(num_in=self.I, num_out=self.O))
        self.dut._log.info('Binary lengths: pt: {pt:d} | idx: {idx:d} | roi: {roi:d} | flags: {flags:d}'.format(pt=self.ptlen, idx=self.idxlen, roi=self.roilen, flags=self.flagslen))
        self.dut._log.info('Top-level: {tp:s}.'.format(tp=self.SM.toplevel))
        #self.dut._log.info('Pre sort set {pre:s}'.format(pre=str(self.presort_in_sets)))
        self.dut._log.info('#' * 50)

        self.gen_muon()
        self.py_sort_muon()
        if self.SM.toplevel == 'work.csn_sort_88_64':
            self.py_net_88_64_sort_muon()
        else:
            self.py_net_sort_muon()

    
    @cocotb.coroutine
    def stim_muon(self, period = 4):
        yield RisingEdge(self.dut.clk)
        self.dut.sink_valid <= 0
        i = 0
        cnt = 0
        while i < self.n:
            yield RisingEdge(self.dut.clk)
            if cnt == period-1:
                self.dut.sink_valid <= 1
                for j in range(self.I):
                    self.dut.muon_i[j].pt <= self.muon_cand[i][j]['pt']
                    #self.dut.muon_i[j].idx <= self.muon_cand[i][j][idx']
                    self.dut.muon_i[j].roi <= self.muon_cand[i][j]['roi']
                    self.dut.muon_i[j].flags <= self.muon_cand[i][j]['flags']
                cnt = 0
                i += 1
            else:
                self.dut.sink_valid <= 0
                cnt += 1

        yield RisingEdge(self.dut.clk)
        self.dut.sink_valid <= 0

    @cocotb.coroutine
    def read_muon(self):
        i = 0
        self.sim_sorted_muon = []
        while i < self.n:
            yield RisingEdge(self.dut.clk)
            yield ReadOnly()
            if self.dut.source_valid.value.is_resolvable:
                if self.dut.source_valid.value.integer:
                    cand = []
                    for j in range(self.O):
                        cand.append({'pt': self.dut.muon_o[j].pt.value.integer,
                                     'idx': self.dut.muon_o[j].idx.value.integer,
                                     'roi': self.dut.muon_o[j].roi.value.integer,
                                     'flags': self.dut.muon_o[j].flags.value.integer,
                                     })
                    self.sim_sorted_muon.append(cand)
                    i += 1


    def gen_muon(self):
        self.muon_cand = []
        for i in range(self.n):
            cand = []
            fraction = random.uniform(*self.val_cand_frac_range)
            n_pt_valid = int(fraction*self.I)
            pt_valid = [random.randint(1, -1 + 2 ** self.ptlen) for _ in range(n_pt_valid)]
            pt_zero = [0]*(self.I - n_pt_valid)
            pt=pt_valid + pt_zero
            random.shuffle(pt)


            if self.SM.presort_in_sets != [set()]:
                for s in self.SM.presort_in_sets:
                    pt[min(s):max(s) + 1] = sorted(pt[min(s):max(s) + 1], reverse=True)

            for j in range(self.I):
                cand.append({'pt': pt[j],
                             'idx': j,
                             'roi': random.randint(0, -1 + 2 ** self.roilen),
                             'flags': random.randint(0, -1 + 2 ** self.flagslen),
                             })

            self.muon_cand.append(cand)





    def py_sort_muon(self):
        self.py_sorted_muon = []
        muon_cand = copy.deepcopy(self.muon_cand)
        for i in range(self.n):
            cand = sorted(muon_cand[i], key=lambda k: k['pt'], reverse = True)
            self.py_sorted_muon.append(cand)



    def py_net_sort_muon(self):
        # copying list
        self.py_net_sorted_muon = copy.deepcopy(self.muon_cand)
        for i in range(self.n):
            for j in self.SM.list_of_pairs: self.SM.SU.compare_and_swap(self.py_net_sorted_muon[i], *j, key=lambda k: k['pt'])
            self.py_net_sorted_muon[i] = self.py_net_sorted_muon[i][0:self.O]

    def py_net_88_64_sort_muon(self):
        # copying list
        self.py_net_sorted_muon = copy.deepcopy(self.muon_cand)
        factor = 4
        for i in range(self.n):
            data_a = []
            data_b = []
            for x in range(factor):
                # sorting each of 4 parts
                data_a.append(self.py_net_sorted_muon[i][x*self.I // factor:(x+1)*self.I // factor])
                for j in self.SM.list_of_pairs_88: self.SM.SU.compare_and_swap(data_a[x], *j, key=lambda k: k['pt'])
                # getting the highest from each subset
                data_b.extend(data_a[x][0 : self.O])
            # sorting the highest 64
            for j in self.SM.list_of_pairs_64: self.SM.SU.compare_and_swap(data_b, *j, key=lambda k: k['pt'])
            self.py_net_sorted_muon[i] = data_b[0:self.O]






    def print_muon(self):
        for i in range(self.n):
            self.dut._log.info('#'*50)
            for muon, name, len in ((self.muon_cand, 'non sorted', self.I) , (self.py_sorted_muon, 'py  sorted', self.O), (self.py_net_sorted_muon, 'py net sorted', self.O), (self.sim_sorted_muon, 'sim sorted', self.O)):
                self.dut._log.info('Printing {name:s} data for clock cycle {i:04d}'.format(i=i, name=name))
                for j in range(len):
                    self.dut._log.info("Id: {input:03d} | pt: 0x{pt:01x} | idx: {idx:03d} | roi: 0x{roi:02x} | flags: 0x{flags:01x}".format(
                        pt=muon[i][j]['pt'], idx=muon[i][j]['idx'], roi=muon[i][j]['roi'], flags=muon[i][j]['flags'], input=j))






@cocotb.coroutine
def run_test(dut, n, ratio, period):
    """
    Testing the Muon Sorter
    """
    tb = MyTB(dut, SM, n, ratio)

    cocotb.fork(Clock(dut.clk, 10).start())
    stim_thread = cocotb.fork(tb.stim_muon(period))
    read_thread = cocotb.fork(tb.read_muon())

    yield stim_thread.join()
    yield read_thread.join()

    if tb.n <= 10:
       tb.print_muon()
    # checking only pt without using list  of pairs
    Pass = True
    for i in range(tb.n):
        for j in range(tb.O):
            if tb.py_sorted_muon[i][j]['pt'] != tb.sim_sorted_muon[i][j]['pt']:                
                Pass = False

    # checking all data using list of pairs comparison
    if tb.py_net_sorted_muon != tb.sim_sorted_muon:       
       Pass = False

    # checking flag
    if not Pass:
        raise TestFailure("Muon sorting failed, look the print report.")
    else:
        raise TestSuccess("Muon sorting successful")






# Generating Tests
SM = SortingModel()
factory = TestFactory(run_test)
factory.add_option("n", [1000])
ratio = 1*[[0,1]]
#ratio = 20*[[0,1]] + 40*[[8.0/352,24.0/352]] + 40*[[0.0/352,8.0/352]]
#ratio = 2000*[[0,1]] + 4000*[[8.0/352,24.0/352]] + 4000*[[0.0/352,8.0/352]]
random.shuffle(ratio)
factory.add_option("ratio", ratio)
factory.add_option("period", [1,4,7])
factory.generate_tests()
