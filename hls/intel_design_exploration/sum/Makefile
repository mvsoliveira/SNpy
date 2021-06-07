SOURCE_FILES  := sum.cpp 
override HLS_CXX_FLAGS := $(HLS_CXX_FLAGS)
SIM?=1
PR?=0  
CXX := i++
DEVICE := 10AS016C3U19E2LG
override CXXFLAGS := $(CXXFLAGS)
VERBOSE?=1

# OS-dependant tools
ifeq ($(OS),Windows_NT)
  RM  := rd /S /Q
else
  RM  := rm -rf
endif

ifeq ($(MAKECMDGOALS),)
  $(info No target specified, defaulting to test-x86-64)
  $(info Available targets: test-x86-64, fpga, test-gpp, clean)
endif

# Any tools installed with HLS can be found relative to the location of i++
HLS_INSTALL_DIR := $(shell which i++ | sed 's|/bin/i++||g')

# Run the i++ x86 test by default
.PHONY: default
default: test-x86-64

# Compile the component and testbench using g++ and run them as a regular program
.PHONY: test-gpp
test-gpp: CXX := g++
test-gpp: CXXFLAGS := $(CXXFLAGS) -std=c++17 -I"$(HLS_INSTALL_DIR)/include" -L"$(HLS_INSTALL_DIR)/host/linux64/lib" -lhls_emul -o test-gpp
test-gpp: $(SOURCE_FILES)
	$(CXX) $(SOURCE_FILES) $(CXXFLAGS)
	@echo "+-------------------------------------+"
	@echo "| Run ./test-gpp to execute the test. |"
	@echo "+-------------------------------------+"

# Run the testbench and the component as a regular program
.PHONY: test-x86-64
test-x86-64: CXXFLAGS := $(CXXFLAGS) $(HLS_CXX_FLAGS) -march=x86-64 -o test-x86-64
test-x86-64: $(SOURCE_FILES)
	$(CXX) $(SOURCE_FILES) $(CXXFLAGS)
	@echo "+----------------------------------------+"
	@echo "| Run ./test-x86-64 to execute the test. |"
	@echo "+----------------------------------------+"

# Run a simulation with the C testbench and verilog component
.PHONY: fpga
ifeq ($(VERBOSE),1)
  fpga: CXXFLAGS := $(CXXFLAGS) -v
endif
ifeq ($(SIM),0)
  fpga: HLS_CXX_FLAGS := $(HLS_CXX_FLAGS) --simulator none
else
  fpga: HLS_CXX_FLAGS := $(HLS_CXX_FLAGS) -ghdl
endif
ifeq ($(PR),1)
  fpga: HLS_CXX_FLAGS := $(HLS_CXX_FLAGS) --quartus-compile
endif
fpga: CXXFLAGS := $(CXXFLAGS) $(HLS_CXX_FLAGS) -march=$(DEVICE) -o fpga 
fpga: $(SOURCE_FILES)
	$(CXX) $(SOURCE_FILES) $(CXXFLAGS)
	@echo "+--------------------------------------+"
	@echo "| Run ./test-fpga to execute the test. |"
	@echo "+--------------------------------------+"
	

# Clean up temprary and delivered files
CLEAN_FILES := test-gpp \
               test-gpp.prj \
               fpga \
               fpga.prj \
               test-x86-64 \
               test-x86-64.prj
clean:
	-$(RM) $(CLEAN_FILES)
