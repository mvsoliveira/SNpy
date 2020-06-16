#!/bin/python
import os
import re
import fnmatch
import pandas as pd

def run_cmd(cmd):
    f = os.popen(cmd)
    return f.read()

def build_project(name,cf):

	#if not os.path.exists("./project.runs/impl_1/compare_main_timing_summary_routed.rpt"):
	#    return None

	os.chdir('../../../')
	run_cmd('cp -r {name:s} {name:s}_ER1'.format(name=name))
	os.chdir('{name:s}_ER1/impl/verilog'.format(name=name))
	run_cmd('cp {file:s} .'.format(file=os.path.join(cf,'compare_wrapper.vhd')))
	run_cmd('cp {file:s} .'.format(file=os.path.join(cf,'settings.tcl')))
	os.system('./impl.sh')	


# getting all the folders with a verilog subfolder
matches = []
pattern = re.compile(ur".+design_exploration2\/withmux_inreg0\/s.+D00[7]_II4.+IR0_R[1].+impl\/verilog$")
for root, dirnames, filenames in os.walk('.'):
    for dirname in dirnames:
	p = os.path.abspath(os.path.join(root, dirname))
        if pattern.match(p):
            print(p)
            matches.append(os.path.abspath(p))

# looping though matches
df = pd.DataFrame()
cf = os.path.abspath('.')
for m in sorted(matches, reverse=True):
    name = [i for i in m.split('/') if 'I352' in i][0]
    print(name,m)
    os.chdir(m)
    build_project(name,cf)
    

os.chdir(cf)


