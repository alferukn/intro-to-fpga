import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

@cocotb.test()
async def sum_reduce_test(dut):
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst.value = 1
    dut.num.value = 0
    await ClockCycles(dut.clk, 2)

    dut.rst.value = 0
    await RisingEdge(dut.clk)
    
    dut.num.value = 1
    await RisingEdge(dut.clk)
    assert dut.sum.value == 1, f"Error on step 1! Exp 1, got {dut.sum.value}"

    dut.num.value = 2
    await RisingEdge(dut.clk)
    assert dut.sum.value == 3, f"Error on step 2! Exp 3, got {dut.sum.value}"

    dut.num.value = 3
    await RisingEdge(dut.clk)
    assert dut.sum.value == 6, f"Error on step 3! Exp 6, got {dut.sum.value}"

    dut.num.value = 0
    await RisingEdge(dut.clk)