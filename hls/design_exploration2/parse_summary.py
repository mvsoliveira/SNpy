#!/bin/python
import os
import re
import fnmatch
import pandas as pd

def run_cmd(cmd):
    f = os.popen(cmd)
    return f.read()

def get_times(type,cols,data):

	#getting individual elements

	with open('./project.runs/{type:s}_1/runme.log'.format(type=type), 'r') as file:
	    test_str = file.read()

	matches = re.finditer(ur"^(?!Time)([a-z\_]+).*elapsed = ([\d\:]+)", test_str, re.MULTILINE)

	timeList = []
	for matchNum, match in enumerate(matches, start=1):
	    #print(match.group(1),match.group(2))
            cols.append('E {type:s} {i:s}'.format(type=type,i=match.group(1)))
            data.append(match.group(2))
	    timeList.append(match.group(2))


	totalSecs = 0
	for tm in timeList:
	    timeParts = [int(s) for s in tm.split(':')]
	    totalSecs += (timeParts[0] * 60 + timeParts[1]) * 60 + timeParts[2]
	totalSecs, sec = divmod(totalSecs, 60)
	hr, min = divmod(totalSecs, 60)
	total =  "%02d:%02d:%02d" % (hr, min, sec)
	cols.append('E {type:s} total'.format(type=type))
	data.append(total)
        return([cols,data])

def parse_project():

	if not os.path.exists("./project.runs/impl_1/compare_main_timing_summary_routed.rpt"):
	    return None

	
	#getting timing information (using deprecated system call because server does not have subprocess)
	cols = run_cmd('sed -n "/Design Timing Summary/ { n; n; n; n; p}" ./project.runs/impl_1/compare_main_timing_summary_routed.rpt')
	data = run_cmd('sed -n "/Design Timing Summary/ { n; n; n; n; n; n; p}" ./project.runs/impl_1/compare_main_timing_summary_routed.rpt')
	cols = ['T {i:s}'.format(i=i) for i in [s.strip() for s in cols.split('  ')] if i]
	data = data.split()
	d = dict(zip(cols,data))

	# getting utilization
	lines = run_cmd("grep '|        Site Type        |' ./report/compare_main_utilization_routed.rpt -A 11")
	lines = lines.splitlines()
	cols = []
	data = []
	for line in lines[2:]:
	    l = [i for i in [e.strip() for e in line.split('|')] if i]
	    cols.append('U {0:s}'.format(l[0]))
	    data.append(l[1])
	    cols.append('U {0:s} (%)'.format(l[0]))
	    data.append(l[4])

	d.update(dict(zip(cols,data)))


	#getting elapsed times
	cols = []
	data  = []
	[cols, data] = get_times('synth',cols,data)
	[cols, data] = get_times('impl',cols,data)

	d.update(dict(zip(cols,data)))


	# getting power
	lines = run_cmd("grep +--------------------------+--------------+ ./project.runs/impl_1/compare_main_power_routed.rpt -A 15 -m 1")
	lines = lines.splitlines()
	cols = []
	data = []
	for line in lines[1:]:
	    l = [i for i in [e.strip() for e in line.split('|')] if i]
	    cols.append('P {0:s}'.format(l[0]))
	    data.append(l[1])

	d.update(dict(zip(cols,data)))
	return(d)


#d = parse_project()    
#print(d)

# getting all the folders with a verilog subfolder
matches = []
pattern = re.compile(ur".+impl\/verilog$")
for root, dirnames, filenames in os.walk('.'):
    for dirname in dirnames:
	p = os.path.join(root, dirname)	
        if pattern.match(p):
            print(p)
            matches.append(os.path.abspath(p))

# looping though matches
df = pd.DataFrame()
cf = os.path.abspath('.')
for m in matches:
    name = [i for i in m.split('/') if 'I352' in i][0]
    print(name,m)
    os.chdir(m)
    d = parse_project()
    if d:
        d.update({'NAME': name}) 
        df = df.append(d, ignore_index=True)   
    #print(d)

os.chdir(cf)

df[[u'NAME', u'T WNS(ns)', u'T TNS(ns)', u'T WHS(ns)',  u'T THS(ns)', u'P Total On-Chip Power (W)', u'U CLB LUTs', u'U CLB LUTs (%)',  u'U CLB Registers', u'U CLB Registers (%)', u'U LUT as Logic',
       u'U LUT as Logic (%)', u'U LUT as Memory', u'U LUT as Memory (%)', u'E impl total', u'E synth synth_design', u'E impl open_checkpoint', u'E impl opt_design',
       u'E impl phys_opt_design', u'E impl place_design',
       u'E impl report_clock_utilization', u'E impl report_control_sets',
       u'E impl report_drc', u'E impl report_io', u'E impl report_methodology',
       u'E impl report_power', u'E impl route_design', 
       u'E impl write_checkpoint', u'E synth create_clock',
       u'E synth total', u'E synth write_checkpoint',
       u'P Confidence Level', u'P Design Nets Matched',
       u'P Design Power Budget (W)', u'P Device Static (W)', u'P Dynamic (W)',
       u'P Effective TJA (C/W)', u'P Junction Temperature (C)',
       u'P Max Ambient (C)', u'P Power Budget Margin (W)', u'P Setting File',
       u'P Simulation Activity File', 
       u'T THS Failing Endpoints', u'T THS Total Endpoints',
       u'T TNS Failing Endpoints', u'T TNS Total Endpoints', u'T TNS(ns)',
       u'T TPWS Failing Endpoints', u'T TPWS Total Endpoints', u'T TPWS(ns)',
       u'T WPWS(ns)', u'U CARRY8', u'U CARRY8 (%)',        
       u'U F7 Muxes', u'U F7 Muxes (%)', u'U F8 Muxes',
       u'U F8 Muxes (%)', u'U F9 Muxes', u'U F9 Muxes (%)', 
       u'U Register as Flip Flop', u'U Register as Flip Flop (%)',
       u'U Register as Latch', u'U Register as Latch (%)']].sort_values(by=[u'NAME']).to_csv('report.csv')


    






