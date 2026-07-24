import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge


class HelperMergeParallel:

    def __init__(self, dut):
        self.dut = dut
        self.expected_1 = 0
        self.expected_2 = 0
        self.seen_1 = False
        self.seen_2 = False

    async def setup(self):
        self.dut.s_valid_1.value = 0
        self.dut.s_data_1.value = 0
        self.dut.s_valid_2.value = 0
        self.dut.s_data_2.value = 0
        self.dut.m_ready.value = 0

    async def initialize_rst(self):
        self.dut.aresetn.value = 0
        await ClockCycles(self.dut.clk, 2)
        self.dut.aresetn.value = 1

    def generate_rnd_input(self):
        self.dut.s_valid_1.value = random.randint(0, 1)
        self.dut.s_data_1.value = random.randint(0, 7)

        self.dut.s_valid_2.value = random.randint(0, 1)
        self.dut.s_data_2.value = random.randint(0, 255)

        self.dut.m_ready.value = random.randint(0, 1) 

    def update_model(self):
        if not self.dut.aresetn.value:
            self.seen_1 = False
            self.seen_2 = False
            self.expected_1 = 0
            self.expected_2 = 0
        else:
            if self.dut.s_valid_1.value and self.dut.s_ready_1.value:
                self.expected_1 = int(self.dut.s_data_1.value)
                self.seen_1 = True

            if self.dut.s_valid_2.value and self.dut.s_ready_2.value:
                self.expected_2 = int(self.dut.s_data_2.value)
                self.seen_2 = True

            if self.dut.m_valid.value and self.dut.m_ready.value:
                self.seen_1 = False
                self.seen_2 = False


@cocotb.test()
async def merge_parallel_test(dut):
    NOfIterations = 1000

    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start(start_high=False))

    helper = HelperMergeParallel(dut)

    await helper.setup()
    await helper.initialize_rst()
    await RisingEdge(dut.clk)

    for _ in range(NOfIterations):
        helper.generate_rnd_input()

        exch_r_1 = bool(dut.s_valid_1.value) and bool(dut.s_ready_1.value)
        exch_r_2 = bool(dut.s_valid_2.value) and bool(dut.s_ready_2.value)

        data_1_val = int(dut.s_data_1.value)
        data_2_val = int(dut.s_data_2.value)

        await RisingEdge(dut.clk)

        if exch_r_1:
            helper.expected_1 = data_1_val
            helper.seen_1 = True

        if exch_r_2:
            helper.expected_2 = data_2_val
            helper.seen_2 = True

        expected_m_valid = int(helper.seen_1 and helper.seen_2)
        assert int(dut.m_valid.value) == expected_m_valid, (
            f"Error m_valid! Got {dut.m_valid.value}, exp {expected_m_valid}"
        )

        if helper.seen_1 and helper.seen_2:
            expected_m_data = (helper.expected_2 << 3) | helper.expected_1
            assert int(dut.m_data.value) == expected_m_data, (
                f"Error m_data! Got {int(dut.m_data.value)}, exp {expected_m_data}"
            )

        if bool(dut.m_valid.value) and bool(dut.m_ready.value):
            helper.seen_1 = False
            helper.seen_2 = False