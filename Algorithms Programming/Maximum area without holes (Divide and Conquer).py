# the biggest area without holes
holes=[]
f=open("holes.txt")
a=f.readline() # read dimensions of the matrix
m=int(a.split()[0])
n=int(a.split()[1])
N=int(f.readline()) # number of holes
for i in range(0,N):
    a=f.readline() # read coordinates of each hole
    x=int(a.split()[0])
    y=int(a.split()[1])
    holes.append((x, y))
max_supr=0
def area(up,left,down,right):
    global max_supr
    global coord
    ok=True
    for g in holes:
        if g[0]>up and g[0]<down and g[1]>left and g[1]<right: 
            ok=False
            area(up,left,g[0],right)
            area(g[0],left,down,right)
            area(up,left,down,g[1])
            area(up,g[1],down,right)
    if ok:
        sup=(right-left)*(down-up)
        if sup>max_supr: max_supr=sup
        coord=(up,left,right,down)
area(0,0,m,n)
print(max_supr,coord)