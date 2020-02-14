x=input("values = ")
val=[int(i) for i in x.split()]
y=input("weights = ")
wt=[int(i) for i in y.split()]
W=int(input('Knapsack Weight = '))
n=len(val) # number of objects
def KS(W,val,wt,n):
    K=[[0 for x in range(W+1)] for x in range(n+1)]
    for i in range(n+1):
        for w in range(W+1):
            if i==0 or w==0:
                K[i][w]=0
            elif wt[i-1]<=w: # if the object i fits in
                K[i][w]=max(val[i-1]+K[i-1][w-wt[i-1]],K[i-1][w])
            else:
                K[i][w]=K[i-1][w]
    return K[n][W]
print(KS(W,val,wt,n))
# example: For val[60,100,120] wt=[10,20,30] W=50 => 220