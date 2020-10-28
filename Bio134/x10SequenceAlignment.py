import x10FetchGenbank as fetch
import x10dotplot as dpl

sids = ['P00846', 'Q95A26', 'Q9T9W0', 'Q2I3G9', 'Q9TA24']
seqdic = {}
for sid in sids:
    fetch.fetch_genbank(sid)
    seqdic[sid]=fetch.read_genbank('files\_10_'+str(sid)+'.genbank')


W=7
total=0
for i,sid1 in enumerate(sids):
    for sid2 in sids[i+1:len(sids)]:
        dpl.plot(seqdic[sid1][1],seqdic[sid2][1],seqdic[sid1][0],seqdic[sid2][0],W)
print (total)