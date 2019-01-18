import cocotb
from cocotb.triggers import *
from cocotb.clock import Clock
from cocotb.result import TestFailure, TestSuccess
import random

N=10

@cocotb.coroutine
def write_stim(clk, ce, signal, data):
    for d in data:
        yield RisingEdge(clk)
        ce <= 1
        signal <= d
    yield RisingEdge(clk)
    ce <= 0
    signal <= 0


@cocotb.coroutine
def check_resp(clk, signal, data):
    for d in data:
        yield RisingEdge(clk)
        yield ReadOnly()
        #signal._log.info('Expected = {e:d}. Found = {f:d}.'.format(e=d,f=int(signal.value)))
        if int(signal.value) != d:
            raise TestFailure("Output didn't match. Expected = {e:d}. Found = {f:d}.".format(e=d,f=int(signal.value)))

    signal._log.info('Data ok')


@cocotb.test()
def main_test(dut):
    """
    Testing the shift register
    """
    dw = int(dut.dw.value)
    clk = dut.clk
    ce = dut.ce
    input = dut.input
    data_in = [random.randint(0, 2**dw) for _ in range(N)]

    dut._log.info("Running test!")
    # generating clock
    cocotb.fork(Clock(dut.clk, 10).start())

    dut.ce = 1
    dut.tap = 0

    stim_thread = cocotb.fork(write_stim(clk, ce, input, data_in))
    check_thread = cocotb.fork(check_resp(dut.clk, dut.output, data_in))

    yield stim_thread.join()
    yield check_thread.join()

    yield Timer(200)

    dut._log.info("Finished")

