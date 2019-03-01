import glob
import re
import csv

basepaths = glob.glob('../syn/*')
basepaths.sort()

extract_info = []
# extract_info.append({'name': 'LUTs',
#                      'rexp': ur"muon_sorter_1\s+(?:\|[^\|]+){1}\|\s+(\d+)",
#                      'file': '/rev_1/par_1/hier_utilization.txt'})
#
# extract_info.append({'name': 'FFs',
#                      'rexp': ur"muon_sorter_1\s+(?:\|[^\|]+){5}\|\s+(\d+)",
#                      'file': '/rev_1/par_1/hier_utilization.txt'})

extract_info.append({'name': 'Logic Levels',
                     'rexp': ur"Logic Levels\s+(?:\|[^\|]+){1}\|\s+(\d+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})
extract_info.append({'name': 'LL-1',
                     'rexp': ur"Logic Levels\s+(?:\|[^\|]+){0}\|\s+(\d+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})
extract_info.append({'name': 'LL+1',
                     'rexp': ur"Logic Levels\s+(?:\|[^\|]+){2}\|\s+(\d+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})

extract_info.append({'name': 'High Fanout',
                     'rexp': ur"High Fanout\s+(?:\|[^\|]+){1}\|\s+(\d+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})
extract_info.append({'name': 'HF-1',
                     'rexp': ur"High Fanout\s+(?:\|[^\|]+){0}\|\s+(\d+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})
extract_info.append({'name': 'HF+1',
                     'rexp': ur"High Fanout\s+(?:\|[^\|]+){2}\|\s+(\d+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})

extract_info.append({'name': 'Cumulative Fanout',
                     'rexp': ur"Cumulative Fanout\s+(?:\|[^\|]+){1}\|\s+(\d+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})
extract_info.append({'name': 'CF-1',
                     'rexp': ur"Cumulative Fanout\s+(?:\|[^\|]+){0}\|\s+(\d+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})
extract_info.append({'name': 'CF+1',
                     'rexp': ur"Cumulative Fanout\s+(?:\|[^\|]+){2}\|\s+(\d+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})

extract_info.append({'name': 'Routes',
                     'rexp': ur"Routes\s+(?:\|[^\|]+){1}\|\s+(\d+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})
extract_info.append({'name': 'Routes-1',
                     'rexp': ur"Routes\s+(?:\|[^\|]+){0}\|\s+(\d+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})
extract_info.append({'name': 'Routes+1',
                     'rexp': ur"Routes\s+(?:\|[^\|]+){2}\|\s+(\d+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})

extract_info.append({'name': 'Requirement',
                     'rexp': ur"Requirement\s+(?:\|[^\|]+){1}\|\s+([\d\.\-]+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})
extract_info.append({'name': 'Req-1',
                     'rexp': ur"Requirement\s+(?:\|[^\|]+){0}\|\s+([\d\.\-]+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})
extract_info.append({'name': 'Req+1',
                     'rexp': ur"Requirement\s+(?:\|[^\|]+){2}\|\s+([\d\.\-]+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})

extract_info.append({'name': 'Path Delay',
                     'rexp': ur"Path Delay\s+(?:\|[^\|]+){1}\|\s+([\d\.\-]+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})
extract_info.append({'name': 'PD-1',
                     'rexp': ur"Path Delay\s+(?:\|[^\|]+){0}\|\s+([\d\.\-]+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})
extract_info.append({'name': 'PD+1',
                     'rexp': ur"Path Delay\s+(?:\|[^\|]+){2}\|\s+([\d\.\-]+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})

extract_info.append({'name': 'Slack',
                     'rexp': ur"Slack\s+(?:\|[^\|]+){1}\|\s+([\d\.\-]+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})
extract_info.append({'name': 'Slack-1',
                     'rexp': ur"Slack\s+(?:\|[^\|]+){0}\|\s+([\d\.\-]+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})
extract_info.append({'name': 'Slack+1',
                     'rexp': ur"Slack\s+(?:\|[^\|]+){2}\|\s+([\d\.\-]+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})

extract_info.append({'name': 'Logic Delay',
                     'rexp': ur"Logic Delay\s+(?:\|[^\|]+){1}\|\s+([\(\)\%\d\.\-]+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})
extract_info.append({'name': 'LD-1',
                     'rexp': ur"Logic Delay\s+(?:\|[^\|]+){0}\|\s+([\(\)\%\d\.\-]+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})
extract_info.append({'name': 'LD+1',
                     'rexp': ur"Logic Delay\s+(?:\|[^\|]+){2}\|\s+([\(\)\%\d\.\-]+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})

extract_info.append({'name': 'Net Delay',
                     'rexp': ur"Net Delay\s+(?:\|[^\|]+){1}\|\s+([\(\)\%\d\.\-]+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})
extract_info.append({'name': 'ND-1',
                     'rexp': ur"Net Delay\s+(?:\|[^\|]+){0}\|\s+([\(\)\%\d\.\-]+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})
extract_info.append({'name': 'ND+1',
                     'rexp': ur"Net Delay\s+(?:\|[^\|]+){2}\|\s+([\(\)\%\d\.\-]+)",
                     'file': '/rev_1/par_1/design_analysis.txt',
                     'indx': 0})

def ext(inf):
    textfile = open(bp + inf['file'], 'r')
    filetext = textfile.read()
    textfile.close()
    matches = re.findall(inf['rexp'], filetext)
    if 'indx' in inf:
        if len(matches)-1 >= inf['indx']:
            return matches[inf['indx']]
        else:
            print matches
            raise Exception('There is no match for {rexp:s} with index {indx:d}'.format(indx=inf['indx'],rexp=inf['rexp']))
    else:
        if len(matches) == 1:
            return matches[0]
        elif len(matches) < 1:
            raise Exception('No matches for {rexp:s}'.format(rexp=inf['rexp']))
        else:
            raise Exception('More than one match for {rexp:s}'.format(rexp=inf['rexp']))

data = []
line = ['Implementation']
for inf in extract_info:
    line.append(inf['name'])
data.append(line)


for bp in basepaths:
    line = [bp]
    for inf in extract_info:
        line.append(ext(inf))
    data.append(line)

with open('report.csv', 'wb') as myfile:
    wr = csv.writer(myfile)
    wr.writerows(data)



