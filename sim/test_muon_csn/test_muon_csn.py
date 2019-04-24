import cocotb
from cocotb.triggers import RisingEdge, Timer, ReadOnly
from cocotb.clock import Clock
from cocotb.result import TestFailure, TestSuccess
from cocotb.regression import TestFactory
import random
import os
import code



class MyTB(object):

    def __init__(self, dut, n):
        self.dut = dut
        self.n = n
        self.I = self.dut.I.value
        self.O = self.dut.O.value
        self.delay = self.dut.delay.value
        self.ptlen = self.dut.muon_sel_i[0].pt.value.n_bits
        #self.sectorlen = self.dut.muon_sel_i[0].sector.value.n_bits
        self.sectorlen = 0
        #self.roilen = self.dut.muon_sel_i[0].roi.value.n_bits
        self.roilen = 0
        self.dut._log.info('#' * 50)
        self.dut._log.info("Testing muon sorter with the following settings:")
        self.dut._log.info('Simulation length: {len: d}'.format(len=self.n))
        self.dut._log.info('Number of candidates: input: {num_in:d} | output: {num_out:d}'.format(num_in=self.I, num_out=self.O))
        self.dut._log.info('Binary lengths: pt: {pt:d} | sector: {sector:d} | roi: {roi:d}'.format(pt=self.ptlen, sector=self.sectorlen, roi=self.roilen))
        self.dut._log.info('#' * 50)
        if self.I == 352:
            presort_in_sets = self.get_muctpi_presort_in_sets()
        elif self.I == 88:
            presort_in_sets = self.get_muctpi_presort_in_sets()[:38]
        elif self.I == 64:
            presort_in_sets = self.get_muctpi_stage_b_presort_in_sets()
        else:
            presort_in_sets = [set()]
        self.gen_muon(presort_in_sets)
        self.py_sort_muon()

    
    @cocotb.coroutine
    def stim_muon(self):
        yield RisingEdge(self.dut.clk)
        #self.dut.sink_valid <= 0
        for i in range(self.n):
            yield RisingEdge(self.dut.clk)
            #self.dut.sink_valid <= 1
            for j in range(self.I):
                self.dut.muon_sel_i[j].pt <= self.muon_cand[i][j]['pt']
                #self.dut.muon_cand[j].sector <= self.muon_cand[i][j]['sector']
                #self.dut.muon_cand[j].roi <= self.muon_cand[i][j]['roi']
        yield RisingEdge(self.dut.clk)
        #self.dut.sink_valid <= 0

    @cocotb.coroutine
    def read_muon(self):
        i = 0
        self.sim_sorted_muon = []
        yield RisingEdge(self.dut.clk)
        yield RisingEdge(self.dut.clk)
        yield RisingEdge(self.dut.clk)
        while i < self.n:
            yield RisingEdge(self.dut.clk)
            yield ReadOnly()
            #if self.dut.source_valid.value.is_resolvable and self.dut.source_valid.value.integer :
            if True :
                cand = []
                for j in range(self.O):
                    cand.append({'pt': self.dut.muon_o[j].pt.value.integer,
                                 'sector': self.dut.muon_o[j].idx.value.integer,
                                 #'roi': self.dut.top_cand[j].roi.value.integer
                                 'roi': 0
                                 })
                self.sim_sorted_muon.append(cand)
                i += 1


    def gen_muon(self, presort_in_sets):
        self.muon_cand = []
        for i in range(self.n):
            cand = []
            pt_valid = [random.randint(1, -1 + 2 ** self.ptlen) for _ in range(self.O)]
            pt_zero = [0]*(self.I-self.O)
            pt=pt_valid + pt_zero
            random.shuffle(pt)

            if presort_in_sets != [set()]:
                for s in presort_in_sets:
                    pt[min(s):max(s) + 1] = sorted(pt[min(s):max(s) + 1], reverse=True)
            for j in range(self.I):
                cand.append({'pt': pt[j],
                             'sector': j,
                             #'roi': random.randint(0, -1 + 2 ** self.roilen)
                             'roi': 0
                             })

            self.muon_cand.append(cand)

    #
    def py_sort_muon(self):
        self.py_sorted_muon = []
        for i in range(self.n):
            k=0
            cand = sorted(self.muon_cand[i], key=lambda k: k['pt'], reverse = True)
            self.py_sorted_muon.append(cand)

    def print_muon(self):
        for i in range(self.n):
            self.dut._log.info('#'*50)
            for muon, name, len in ((self.muon_cand, 'non sorted', self.I) , (self.py_sorted_muon, 'py  sorted', self.O), (self.sim_sorted_muon, 'sim sorted', self.O)):
                self.dut._log.info('Printing {name:s} data for clock cycle {i:04d}'.format(i=i, name=name))
                for j in range(len):
                    self.dut._log.info("Id: {input:03d} | pt: 0x{pt:01x} | sector: 0x{sector:02x} | roi: 0x{roi:02x}".format(
                        pt=muon[i][j]['pt'], sector=muon[i][j]['sector'], roi=muon[i][j]['roi'], input=j))

    def get_muctpi_presort_in_sets(self):
        rpc = [2]
        tgc = [4]
        all = 32 * rpc + 72 * tgc
        presort_in_sets = []
        i = 0
        for cand_sec in all:
            presort_in_sets.append(set(range(i, i + cand_sec)))
            i += cand_sec
        return presort_in_sets

    def get_muctpi_stage_b_presort_in_sets(self):
        cand = [16]
        all = 4 * cand
        presort_in_sets = []
        i = 0
        for cand_sec in all:
            presort_in_sets.append(set(range(i, i + cand_sec)))
            i += cand_sec
        return presort_in_sets




@cocotb.test()
def run_test(dut):
    """
    Testing the Muon Sorter
    """
    tb = MyTB(dut,int(os.environ['SIM_LEN']))
    cocotb.fork(Clock(dut.clk, 10).start())
    stim_thread = cocotb.fork(tb.stim_muon())
    read_thread = cocotb.fork(tb.read_muon())
    yield stim_thread.join()
    yield read_thread.join()
    tb.print_muon()
    Pass = True
    for i in range(tb.n):
        for j in range(tb.O):
            if tb.py_sorted_muon[i][j]['pt'] != tb.sim_sorted_muon[i][j]['pt']:
                Pass = False


    #if tb.py_sorted_muon != tb.sim_sorted_muon:
    if not Pass:
        raise TestFailure("Muon sorting failed, look the print report.")
    else:
        raise TestSuccess("Muon sorting successful")




# Generating Tests
# taps = range(0, 2 ** 5)
# factory = TestFactory(run_test)
# factory.add_option("tap", taps)
# factory.add_option("n", [10, 100])
# factory.generate_tests()
