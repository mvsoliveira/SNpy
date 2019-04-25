import cocotb
from cocotb.triggers import RisingEdge, Timer, ReadOnly
from cocotb.clock import Clock
from cocotb.result import TestFailure, TestSuccess
from cocotb.regression import TestFactory
import random
import os
from sys import path
path.append(os.getcwd() + "/../../../src/py")
from SortingUtils import SortingUtils
import copy




class MyTB(object):

    def __init__(self, dut, n, ratio, toplevel):
        self.dut = dut
        self.n = n
        self.toplevel = toplevel
        self.I = self.dut.I.value
        self.O = self.dut.O.value
        #self.delay = self.dut.delay.value
        self.val_cand_frac = ratio
        self.ptlen = self.dut.muon_i[0].pt.value.n_bits
        #self.sectorlen = self.dut.muon_i[0].sector.value.n_bits
        self.sectorlen = 0
        #self.roilen = self.dut.muon_i[0].roi.value.n_bits
        self.roilen = 0
        self.SU = SortingUtils()
        self.net_sets = (
        I, O, self.presort_in_sets, self.used_out_set, self.nonsorted_out_set) = self.SU.get_muctpi_opt_sets(self.I)
        [self.list_of_pairs, self.net] = self.SU.get_muctpi_sel_net(gen_plots=False, net_sets=self.net_sets)
        self.dut._log.info('#' * 50)
        self.dut._log.info("Testing muon sorter with the following settings:")
        self.dut._log.info('Simulation length: {len: d}'.format(len=self.n))
        self.dut._log.info('Number of candidates: input: {num_in:d} | output: {num_out:d}'.format(num_in=self.I, num_out=self.O))
        self.dut._log.info('Binary lengths: pt: {pt:d} | sector: {sector:d} | roi: {roi:d}'.format(pt=self.ptlen, sector=self.sectorlen, roi=self.roilen))
        self.dut._log.info('Top-level: {tp:s}.'.format(tp=self.toplevel))
        #self.dut._log.info('Pre sort set {pre:s}'.format(pre=str(self.presort_in_sets)))
        self.dut._log.info('#' * 50)

        self.gen_muon()
        self.py_sort_muon()
        if self.toplevel == 'work.csn_sort_88_64':
            self.py_net_88_64_sort_muon()
        else:
            self.py_net_sort_muon()

    
    @cocotb.coroutine
    def stim_muon(self):
        yield RisingEdge(self.dut.clk)
        self.dut.sink_valid <= 0
        for i in range(self.n):
            yield RisingEdge(self.dut.clk)
            self.dut.sink_valid <= 1
            for j in range(self.I):
                self.dut.muon_i[j].pt <= self.muon_cand[i][j]['pt']
                #self.dut.muon_cand[j].sector <= self.muon_cand[i][j]['sector']
                #self.dut.muon_cand[j].roi <= self.muon_cand[i][j]['roi']
        yield RisingEdge(self.dut.clk)
        self.dut.sink_valid <= 0

    @cocotb.coroutine
    def read_muon(self):
        i = 0
        self.sim_sorted_muon = []
        while i < self.n:
            yield RisingEdge(self.dut.clk)
            yield ReadOnly()
            if self.dut.source_valid.value.is_resolvable and self.dut.source_valid.value.integer :
                cand = []
                for j in range(self.O):
                    cand.append({'pt': self.dut.muon_o[j].pt.value.integer,
                                 'sector': self.dut.muon_o[j].idx.value.integer,
                                 #'roi': self.dut.top_cand[j].roi.value.integer
                                 'roi': 0
                                 })
                self.sim_sorted_muon.append(cand)
                i += 1


    def gen_muon(self):
        self.muon_cand = []
        for i in range(self.n):
            cand = []
            n_pt_valid = int(self.val_cand_frac*self.I)
            pt_valid = [random.randint(1, -1 + 2 ** self.ptlen) for _ in range(n_pt_valid)]
            pt_zero = [0]*(self.I - n_pt_valid)
            pt=pt_valid + pt_zero
            random.shuffle(pt)


            if self.presort_in_sets != [set()]:
                for s in self.presort_in_sets:
                    pt[min(s):max(s) + 1] = sorted(pt[min(s):max(s) + 1], reverse=True)

            for j in range(self.I):
                cand.append({'pt': pt[j],
                             'sector': j,
                             #'roi': random.randint(0, -1 + 2 ** self.roilen)
                             'roi': 0
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
            for j in self.list_of_pairs: self.SU.compare_and_swap(self.py_net_sorted_muon[i], *j, key=lambda k: k['pt'])
            self.py_net_sorted_muon[i] = self.py_net_sorted_muon[i][0:self.O]

    def py_net_88_64_sort_muon(self):
        # copying list
        self.py_net_sorted_muon = copy.deepcopy(self.muon_cand)
        self.net_sets_88 = self.SU.get_muctpi_opt_sets(88)
        [self.list_of_pairs_88, net] = self.SU.get_muctpi_sel_net(gen_plots=False, net_sets=self.net_sets_88)
        self.net_sets_64 = self.SU.get_muctpi_opt_sets(64)
        [self.list_of_pairs_64, net] = self.SU.get_muctpi_sel_net(gen_plots=False, net_sets=self.net_sets_64)

        factor = 4
        for i in range(self.n):
            data_a = []
            data_b = []
            for x in range(factor):
                # sorting each of 4 parts
                data_a.append(self.py_net_sorted_muon[i][x*self.I/factor:(x+1)*self.I/factor])
                for j in self.list_of_pairs_88: self.SU.compare_and_swap(data_a[x], *j, key=lambda k: k['pt'])
                # getting the highest from each subset
                data_b.extend(data_a[x][0 : self.O])
            # sorting the highest 64
            for j in self.list_of_pairs_64: self.SU.compare_and_swap(data_b, *j, key=lambda k: k['pt'])
            self.py_net_sorted_muon[i] = data_b[0:self.O]






    def print_muon(self):
        for i in range(self.n):
            self.dut._log.info('#'*50)
            for muon, name, len in ((self.muon_cand, 'non sorted', self.I) , (self.py_sorted_muon, 'py  sorted', self.O), (self.py_net_sorted_muon, 'py net sorted', self.O), (self.sim_sorted_muon, 'sim sorted', self.O)):
                self.dut._log.info('Printing {name:s} data for clock cycle {i:04d}'.format(i=i, name=name))
                for j in range(len):
                    self.dut._log.info("Id: {input:03d} | pt: 0x{pt:01x} | sector: {sector:03d} | roi: 0x{roi:02x}".format(
                        pt=muon[i][j]['pt'], sector=muon[i][j]['sector'], roi=muon[i][j]['roi'], input=j))






@cocotb.coroutine
def run_test(dut, ratio):
    """
    Testing the Muon Sorter
    """
    n = int(os.environ['SIM_LEN'])
    toplevel = os.environ['TOPLEVEL']
    #ratio = float(os.environ['VAL_CAND_FRAC'])
    tb = MyTB(dut, n, ratio, toplevel)
    cocotb.fork(Clock(dut.clk, 10).start())
    stim_thread = cocotb.fork(tb.stim_muon())
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

    #checking all data using list of pairs comparison
    if tb.py_net_sorted_muon != tb.sim_sorted_muon:
       Pass = False

    if not Pass:
        raise TestFailure("Muon sorting failed, look the print report.")
    else:
        raise TestSuccess("Muon sorting successful")




# Generating Tests
factory = TestFactory(run_test)
factory.add_option("ratio", [r/10.0 for r in range(11)])
#factory.add_option("ratio", [0.05])
factory.generate_tests()
