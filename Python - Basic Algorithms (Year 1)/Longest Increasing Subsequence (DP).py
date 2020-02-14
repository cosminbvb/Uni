x=input('v = ')
v = [int(i) for i in x.split()]
def LIS(v):
    n=len(v)
    t=[1]*n
    for i in range(n):
        for j in range(i):
            if v[i]>v[j] and t[i]<t[j]+1:
                t[i]=t[j]+1
    print('L = '+str(max(t)))
LIS(v)