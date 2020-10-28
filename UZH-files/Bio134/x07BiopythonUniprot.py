import Bio
import x07GenBankFastaConversion as convert

def fetch_seq(sid):

    try:
        handle = Bio.ExPASy.get_sprot_raw(sid)
        seq = Bio.SeqIO.read(handle,'swiss')
        Bio.SeqIO.write(seq, 'files/07_'+sid+'.genbank.txt','genbank')
        print ('Sequence length',len(seq))
    except Exception:
        print ('Sequence not found')
    
    
inp=input('What is the sequence name? ')
try:
    fetch_seq(inp)
    convert.filename('07_B4F440.genbank.txt')
    print(inp,' fetched and converted')
except Exception:
    print ("Something didn't work")