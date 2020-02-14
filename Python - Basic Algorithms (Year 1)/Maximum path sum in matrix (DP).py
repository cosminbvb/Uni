# starting from the top-left corner
fin = open('in.txt','r')
n=int(fin.readline()) # lines
m=int(fin.readline()) # columns
M=[]
for line in fin.readlines():
    M.append( [ int (x) for x in line.split(',') ] )
t=[[0 for i in range(m+1)] for i in range(n+1)]
t[0][0]=M[0][0]
for i in range(n):
    for j in range(m):
        t[i][j]=M[i][j]+max(t[i-1][j],t[i][j-1])
print(t[n-1][m-1])
'''
Example:
M=[[5,10,2,7,9,4],[1,3,6,15,2,3],[50,4,9,8,1,1],[2,1,7,2,6,5],[9,2,10,20,15,2]]
n=5 
m=6 
=> 123
'''