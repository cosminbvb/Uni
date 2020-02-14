# Place n queens on a n*n chess board
# there is no solution for n=2 or n=3
n=int(input('n = '))
table=[[0 for i in range(n)] for i in range(n)]
st=[0]*n
# k=line, st[k]=column
def back(k):
    for i in range(n):
        st[k]=i
        if valid(k):
            if k==n-1:
                afis(k)
            else:
                back(k+1)
def valid(k):
    for i in range(k):
        if i==k: return False # if on the same line
        if st[i]==st[k]: return False # if on the same column
        if k-i==abs(st[k]-st[i]): return False # if on the same diagonal
    return True
def afis(k):
    global table, nr
    for i in range(k+1):
        table[i][st[i]]=1
    for x in table: print(x)
    print('----------------------')
    table = [[0 for i in range(n)] for i in range(n)]
back(0)