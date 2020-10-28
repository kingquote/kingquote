from Bio import ExPASy, SeqIO

#this function fetches a genbank file from Uniprot
def fetch_genbank(sid):
    try:
        handle = ExPASy.get_sprot_raw(sid)
        seq = SeqIO.read(handle,'swiss')
        SeqIO.write(seq, 'files\_10_'+sid+'.genbank','genbank')
        print(sid,'sequence length',len(seq))
    except Exception:
        print (sid,'not found')

#this function extracts the organism name and the sequence
#from a local genbank file
def read_genbank(fname):
    f = open(fname)
    for p in SeqIO.parse(f,'genbank'):
        break
    f.close()
    return p.annotations['organism'],str(p.seq)