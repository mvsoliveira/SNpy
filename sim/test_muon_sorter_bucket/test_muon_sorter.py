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
        self.num_in = self.dut.num_in.value
        self.num_out = self.dut.num_out.value
        self.delay = self.dut.delay.value
        self.ptlen = self.dut.muon_cand[0].pt.value.n_bits
        self.sectorlen = self.dut.muon_cand[0].sector.value.n_bits
        self.roilen = self.dut.muon_cand[0].roi.value.n_bits
        self.dut._log.info('#' * 50)
        self.dut._log.info("Testing muon sorter with the following settings:")
        self.dut._log.info('Simulation length: {len: d}'.format(len=self.n))
        self.dut._log.info('Number of candidates: input: {num_in:d} | output: {num_out:d}'.format(num_in=self.num_in,num_out=self.num_out))
        self.dut._log.info('Binary lengths: pt: {pt:d} | sector: {sector:d} | roi: {roi:d}'.format(pt=self.ptlen, sector=self.sectorlen, roi=self.roilen))
        self.dut._log.info('#' * 50)
        self.gen_muon()
        self.py_sort_muon()

    
    @cocotb.coroutine
    def stim_muon(self):
        yield RisingEdge(self.dut.clk)
        self.dut.sink_valid <= 0
        for i in range(self.n):
            yield RisingEdge(self.dut.clk)
            self.dut.sink_valid <= 1
            for j in range(self.num_in):
                self.dut.muon_cand[j].pt <= self.muon_cand[i][j]['pt']
                self.dut.muon_cand[j].sector <= self.muon_cand[i][j]['sector']
                self.dut.muon_cand[j].roi <= self.muon_cand[i][j]['roi']
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
                for j in range(self.num_out):
                    cand.append({'pt': self.dut.top_cand[j].pt.value.integer,
                                 'sector': self.dut.top_cand[j].sector.value.integer,
                                 'roi': self.dut.top_cand[j].roi.value.integer})
                self.sim_sorted_muon.append(cand)
                i += 1


    def gen_muon(self):
        self.muon_cand = []
        for i in range(self.n):
            cand = []
            for j in range(self.num_in):
                cand.append({'pt': random.randint(0, -1 + 2 ** self.ptlen),
                             'sector': random.randint(0, -1 + 2 ** self.sectorlen),
                             'roi': random.randint(0, -1 + 2 ** self.roilen)})
            self.muon_cand.append(cand)

    def py_sort_muon(self):
        self.py_sorted_muon = []
        for i in range(self.n):
            k=0
            cand = []
            for t in range(2**self.ptlen-1,-1,-1):
                for j in range(self.num_in-1,-1,-1):
                    if self.muon_cand[i][j]['pt'] == t:
                        if k < self.num_out:
                            cand.append(self.muon_cand[i][j])
                        else:
                            break
                        k += 1
            self.py_sorted_muon.append(cand)

    def print_muon(self):
        for i in range(self.n):
            self.dut._log.info('#'*50)
            for muon, name, len in ((self.muon_cand, 'non sorted', self.num_in) , (self.py_sorted_muon, 'py  sorted', self.num_out), (self.sim_sorted_muon, 'sim sorted', self.num_out)):
                self.dut._log.info('Printing {name:s} data for clock cycle {i:04d}'.format(i=i, name=name))
                for j in range(len):
                    self.dut._log.info("Id: {input:03d} | pt: 0x{pt:01x} | sector: 0x{sector:01x} | roi: 0x{roi:02x}".format(
                        pt=muon[i][j]['pt'], sector=muon[i][j]['sector'], roi=muon[i][j]['roi'], input=j))




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
    if tb.py_sorted_muon != tb.sim_sorted_muon:
        raise TestFailure("Muon sorting failed, look the print report.")
    else:
        raise TestSuccess("Muon sorting successful")




# Generating Tests
# taps = range(0, 2 ** 5)
# factory = TestFactory(run_test)
# factory.add_option("tap", taps)
# factory.add_option("n", [10, 100])
# factory.generate_tests()
