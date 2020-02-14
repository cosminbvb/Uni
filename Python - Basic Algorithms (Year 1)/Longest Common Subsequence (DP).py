l1=input('First word is: ')
l2=input('Second word is: ')
m=len(l1)
n=len(l2)
L=[[None]*(n+1) for i in range(m+1)]
for i in range(m+1):
    for j in range(n+1):
        if i==0 or j==0: L[i][j]=0
        elif l1[i-1]==l2[j-1]:
            L[i][j]=L[i-1][j-1]+1
        else:
            L[i][j]=max(L[i-1][j],L[i][j-1])
print(L[m][n])