import time
import program_analyzer as PA
import sol_selector as SS
from dapp_analyzer import dic_to_string


def get_program_from_file(filepath):
    return PA.main(filepath)


def get_contract_from_file(filepath, name):
    p = get_program_from_file(filepath)
    for c in p.contracts:
        if c.sign['name'] == name:
            return c


def get_functions_from_file(filepath, name):
    p = get_program_from_file(filepath)
    res = []
    for c in p.contracts:
        for f in c.functions:
            if ' '.join(f.sign['name']) == name:
                res.append(f)
    return res


def find_function(function_name, contract_name, program):
    for c in program.contracts:
        if c.sign['name'] == contract_name:
            for f in c.functions:
                if ' '.join(f.sign['name']) == function_name:
                    return f


def compare_program(a, b, mode='function', ignore_contracts=[]):
    idx, content = a.compare_with(b, mode, ignore_contracts)
    if idx == 0:
        return 'No similarity'
    elif idx == 1:
        return content
    elif idx == 2:
        return dic_to_string(0, content)


def compare_function_with_contract(function, contract, mode='function'):
    contents = {}
    flag = 0
    for f in contract.functions:
        idx, content = function.compare_with(f, mode)
        if idx != 0:
            contents[' '.join(f.name)] = content
            flag = 1
    return flag, contents


def compare_function_with_program(function, program, mode='function', ignore_contracts=[]):
    contents = {}
    flag = 0
    for c in program.contracts:
        if c.sign['name'] in ignore_contracts:
            continue
        idx, content = compare_function_with_contract(function, c, mode)
        if idx != 0:
            contents[' '.join(c.name)] = content
            flag = 2
    return flag, contents


def main(mode='ratio0.8'):
    def init_programs():
        data = 'smart_contracts_sol.log'
        programs = []
        with open(data, 'r', encoding='utf-8') as f:
            for line in f:
                '''if '@' in line:
                    continue'''
                # print(line)
                file = line.strip()
                p = get_program_from_file(file)
                programs.append(p)
        return programs

    def init_functions():
        functions = []
        data = 'functions_sol.log'
        with open(data, 'r', encoding='utf-8') as f:
            for line in f:
                # print(line)
                words = line.strip().split(',')
                file = words[0]
                funcs = words[1:]
                for fn in funcs:
                    fs = get_functions_from_file(file, fn)
                    function = fs[-1]
                    functions.append(function)
        return functions

    programs = init_programs()
    print('--program init finished')
    functions = init_functions()
    print('--function init finished')
    # exit(0)
    w = open('essential_dup'+mode+'.log', 'w', encoding='utf-8')
    #res = ''
    f_idx = 1
    for f in functions:
        print('>>(%d/%d)function: ' % (f_idx, len(functions))
              + ' '.join(f.sign['name']))
        #res += ((' '.join(f.name)).center(80, "-")+'\n')
        w.write('>>> FUNCTION: "' + ' '.join(f.name)+'"\n')
        l_bar = 50
        print("START COMPARE".center(l_bar, "-"))
        start = time.perf_counter()
        n = len(programs)
        p_idx = 0
        flag = 0
        for p in programs:
            bi = int(p_idx/(n-2)*l_bar)
            ba = "*" * bi
            bb = "." * (l_bar - bi)
            bc = (bi / l_bar) * 100
            dur = time.perf_counter() - start
            print("\r{:^3.0f}%[{}->{}]{:.2f}s".format(bc, ba, bb, dur), end="")

            idx, content = compare_function_with_program(f, p, mode=mode)
            if idx != 0:
                #res += ('>> '+p.name+': \n')
                #res += (dic_to_string(0, content)+'\n')
                w.write('>> '+p.name+': \n')
                w.write(dic_to_string(0, content)+'\n')
                flag = 1
            p_idx += 1
        print("\n"+"END COMPARE".center(l_bar, "-"))
        if flag == 0:
            w.write('No Similar Function\n')
        w.write('-'*50 + '\n\n')
        f_idx += 1
    w.close()


def test():
    line = './auction/001.Auction.DApp.backend.contracts.AuctionRepository.sol'
    p = get_program_from_file('smart_contracts' + line.strip()[1:])
    p.print()


def init():
    contract_dir = 'smart_contracts'
    # function_dir='functions'
    SS.print_list_dir(contract_dir, open(contract_dir+'_sol.log', 'w'))
    #SS.print_list_dir(function_dir,open(function_dir+'_sol.log', 'w'))


init()
main(mode='')
# test()
