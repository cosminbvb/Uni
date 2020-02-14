f=open("objects.txt")
v=[]
n=int(f.readline()) # read number of objects
for i in range(0,n):
    g=f.readline() # read value and weight
    v.append((int(g.split()[0]),int(g.split()[1])))
g=int(f.readline()) # read knapsack total weight
def sort(x):
    return x[0]//x[1]
v.sort(key=sort, reverse=True)
i=0
val=0
while g>=v[i][1]:
    val+=v[i][0]
    g-=v[i][1]
    i+=1
if g>0:
    r=g/v[i][1]
    val+=r*v[i][0]
print("Total value = "+str(val))