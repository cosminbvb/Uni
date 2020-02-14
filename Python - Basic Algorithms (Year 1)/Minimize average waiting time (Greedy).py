# Minimize average waiting time
f=open("tis.txt")
g=f.readline()
v=[] # v[i] = estimated time for each person
i=1
s=0
for x in g.split():
    v.append((i,int(x)))
    i+=1
    s+=int(x)
def AverageTime(v):
    time=0
    total=0
    for x in v:
        time+=x[1]
        total+=time
    pers=len(v)
    print("Medium time is: "+str(total/pers))
AverageTime(v) # Average waiting time before sorting
def sortare(v):
    return v[1]
v.sort(key=sortare)
AverageTime(v) # Average waiting time after sorting