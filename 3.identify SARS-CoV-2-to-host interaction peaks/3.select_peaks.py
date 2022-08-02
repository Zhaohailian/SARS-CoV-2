import os,sys
fh1=open(sys.argv[1],'r')
fh2=open(sys.argv[2],'r')
threshold=float(sys.argv[3])

peaks={}
for line in fh1:
 s=line.strip().split('\t')
 if float(s[4]) >= threshold:
  if s[0] not in peaks:
   peaks[s[0]]=1
  else:
   print("Repeated lines!!!")
   exit(line)

for line in fh2:
 s=line.strip().split('\t')
 if s[3] in peaks:
  print(line.strip())

fh1.close()
fh2.close()


