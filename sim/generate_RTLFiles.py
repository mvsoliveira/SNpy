
import glob

setdict = [
    {'path' : ['../src/rtl/'],
     'ext' : 'vhd',
     'fmt' : 'VHDL_SOURCES += $(PWD)/../{path:s}\n'},
    {'path' : ['../src/rtl/'],
     'ext' : 'sv',
     'fmt' : 'VERILOG_SOURCES += $(PWD)/../{path:s}\n'}
    ]


def generate_calls(setdict):
    str = ''
    for p in setdict['path']:
        files =  glob.glob('{path:s}*.{ext:s}'.format(path=p,ext=setdict['ext']))
        for f in files:
            str += setdict['fmt'].format(path=f)
    return str



str = ''
for s in setdict:
    str += generate_calls(s)

with open('RTLFiles.inc', 'w') as text_file:
    text_file.write(str)