cdn = {}
cdn['ttt'] = cdn['ttc'] = 'F phenylalanine'
cdn['tta'] = cdn['ttg'] = 'L leucine'
cdn['tct'] = cdn['tcc'] = cdn['tca'] = cdn['tcg'] = 'S serine'
cdn['tat'] = cdn['tac'] = 'Y tyrosine'
cdn['taa'] = cdn['tag'] = '* stop'
cdn['tgt'] = cdn['tgc'] = 'C cysteine'
cdn['tga'] = '* stop'
cdn['tgg'] = 'W tryptophan'
cdn['ctt'] = cdn['ctc'] = cdn['cta'] = cdn['ctg'] = 'L leucine'
cdn['cct'] = cdn['ccc'] = cdn['cca'] = cdn['ccg'] = 'P proline'
cdn['cat'] = cdn['cac'] = 'H histidine'
cdn['caa'] = cdn['cag'] = 'Q glutamine'
cdn['cgt'] = cdn['cgc'] = cdn['cga'] = cdn['cgg'] = 'R arginine'
cdn['att'] = cdn['atc'] = cdn['ata'] = 'I isoleucine'
cdn['atg'] = 'M methionine'
cdn['act'] = cdn['acc'] = cdn['aca'] = cdn['acg'] = 'T threonine'
cdn['aat'] = cdn['aac'] = 'N asparagine'
cdn['aaa'] = cdn['aag'] = 'K lysine'
cdn['agt'] = cdn['agc'] = 'S serine'
cdn['aga'] = cdn['agg'] = 'R arginine'
cdn['gtt'] = cdn['gtc'] = cdn['gta'] = cdn['gtg'] = 'V valine'
cdn['gct'] = cdn['gcc'] = cdn['gca'] = cdn['gcg'] = 'A alanine'
cdn['gat'] = cdn['gac'] = 'D aspartic acid'
cdn['gaa'] = cdn['gag'] = 'E glutamic acid'
cdn['ggt'] = cdn['ggc'] = cdn['gga'] = cdn['ggg'] = 'G glycine'

#note:series of g in beginning and end are junk
dna = 'gggggggatgagtaaaggagaagaacttttcactggagttgttccaattcttgttgaattagatggtgg'
amino = 'M'

l = dna.partition('atg') #produces tuple with entries: ['*before atg*, 'atg', '*after atg*']

for i in range(0,len(l[2]),3): #decodes from that first atg to the end
    if len(l[2][i:i+3]) == 3:  #avoids error with less than a triplet left at end
        amino += (cdn[l[2][i:i+3]][0])
