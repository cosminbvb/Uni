x=input('the numbers are: ')
v=[int(i) for i in x.split()]
n=len(v)
def OptimalStrategy():
    # Returns optimal possible value that
    # a player can collect from an array
    # of coins of size n. Note than n must be even
    m=[[0 for i in range(n)] for i in range(n)]
    for gap in range(n):
        for j in range(gap,n):
            i=j-gap
            x=0
            if (i+2)<=j:
                x=m[i+2][j]
            y=0
            if (i+1)<=(j-1):
                y=m[i+1][j-1]
            z=0
            if i<=(j-2):
                z=m[i][j-2]
            m[i][j]=max(v[i]+min(x,y),v[j]+min(y,z))
    return m[0][n-1]
print('Maximum value: '+str(OptimalStrategy()))