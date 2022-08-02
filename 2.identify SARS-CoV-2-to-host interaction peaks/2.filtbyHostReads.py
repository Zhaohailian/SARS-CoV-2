import os,sys
fh1=open(sys.argv[1],'r')
fh2=open(sys.argv[2],'r')
out=open(sys.argv[3],'w')

reads={}
for line in fh1:
 s=line.strip().split('\t')
 if s[3] not in reads:
  reads[s[3]]=1
 else:
  print(line)
  exit("Repeated lines!!!")

for line in fh2:
 s=line.strip().split('\t')
 if s[3] in reads:
  out.writelines(line)

fh1.close()
fh2.close()
out.close()


