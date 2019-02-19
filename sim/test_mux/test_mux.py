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
        self.AW = self.dut.AW.value
        self.DW = self.dut.DW.value
        self.delay = self.dut.delay.value
        self.dut._log.info('#' * 50)
        self.dut._log.info("Testing mux with the following settings:")
        self.dut._log.info('Simulation length: {len: d}'.format(len=self.n))
        self.dut._log.info('Address width: {AW:d} | Data width: {DW:d}'.format(AW=self.AW,DW=self.DW))
        self.dut._log.info('#' * 50)
        self.gen_input()
        self.gen_py_sel_input()

    
    @cocotb.coroutine
    def stim_mux(self):
        self.dut.sink_valid <= 0
        self.dut.sel <= 0
        for k in range(2 ** self.AW):
            self.dut.input[k] <= 0
        yield RisingEdge(self.dut.clk)
        for k in range(2 ** self.AW):
            self.dut.input[k] <= self.input[k]
        for i in range(self.n):
            yield RisingEdge(self.dut.clk)
            self.dut.sink_valid <= 1
            self.dut.sel <= self.addr[i]
        yield RisingEdge(self.dut.clk)
        self.dut.sink_valid <= 0

    @cocotb.coroutine
    def read_mux(self):
        i = 0
        self.sim_mux_sel = []
        while i < self.n:
            yield RisingEdge(self.dut.clk)
            yield ReadOnly()
            if self.dut.source_valid.value.is_resolvable and self.dut.source_valid.value.integer:
                self.sim_mux_sel.append(self.dut.output.value.integer)
                i += 1


    def gen_input(self):
        self.input = []
        for i in range(2**self.AW):
            self.input.append(random.randint(0,2**self.DW-1))
        self.addr = []
        for i in range(self.n):
            self.addr.append(random.randint(0,2**self.AW-1))


    def gen_py_sel_input(self):
        self.py_sel_input = []
        for i in range(self.n):
            self.py_sel_input.append(self.input[self.addr[i]])



@cocotb.test()
def run_test(dut):
    """
    Testing the Mux Selection
    """
    tb = MyTB(dut,int(os.environ['SIM_LEN']))
    cocotb.fork(Clock(dut.clk, 10).start())
    stim_thread = cocotb.fork(tb.stim_mux())
    read_thread = cocotb.fork(tb.read_mux())
    yield stim_thread.join()
    yield read_thread.join()
    if tb.sim_mux_sel != tb.py_sel_input:
        raise TestFailure("Mux selection failed.")
    else:
        raise TestSuccess("Mux sel successful")




# Generating Tests
# taps = range(0, 2 ** 5)
# factory = TestFactory(run_test)
# factory.add_option("tap", taps)
# factory.add_option("n", [10, 100])
# factory.generate_tests()
