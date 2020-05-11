from pathlib import Path
import subprocess


Is = [352]
Os = [16]
Ds = list(range(1,9))
muxs = [0, 1]
flats = [0, 1]
in_regs = [0, 1]

origin_dir = './'
Makefile_fmt = 'export VSIM_ARGS+=-gI={I:d} -gO={O:d} -gD={D:d} -gmux={mux:d} -gin_reg={in_reg:d} -gflat={flat:d}\ninclude ../Makefile.inc\n'

create = True
execute = True
results = True

with open(origin_dir+'/tests.log','w') as test:

    for I in Is:
        for O in Os:
            for D in Ds:
                for mux in muxs:
                    for flat in flats:
                        for in_reg in in_regs:
                            name = 'I{I:03d}_O{O:03d}_D{D:03d}_M{mux:01d}_F{flat:01d}_IR{in_reg:01d}'.format(I=I,O=O,D=D,mux=mux,flat=flat,in_reg=in_reg)
                            print('Working on '+name)
                            path = origin_dir+name
                            if create:
                                # creating directory                            
                                Path(path).mkdir(parents=True, exist_ok=True)
                                # creating Makefile
                                with open(path+'/Makefile', 'w') as file:
                                    file.write(Makefile_fmt.format(I=I,O=O,D=D,mux=mux,flat=flat,in_reg=in_reg))       
                            if execute:
                                with open(path+'/cocotb.log', 'w+') as log:
                                    p = subprocess.run(["make"],stdout=log, stderr=log, cwd=path)                                
                                    out = log.read()
                            
                            if results:
                                filtered_lines = [ line for line in open(path+'/cocotb.log', 'r') if '** test_muon_csn.' in line]
                                test.write(name+'\n')
                                test.writelines(filtered_lines)
                                
                                
                            
                                
                        
                                
                                
                        