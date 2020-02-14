# Find the coin combination to pay a sum with a minimum number of coins
x=input('coins = ')
coins=[int(i) for i in x.split()]
s=int(input('sum = '))
n=len(coins)
t=[[0,0]]*(s+1) # ([last coin used to pay for the sum i, the number of coins used for paying the sum i])
for i in range(1,s+1):
    if i in coins: t[i]=[i,1]
    else:
        j=i-1
        while t[i]==[0,0]:
            if t[j]!=[0,0] : t[i]=[t[j][0],t[j][1]+1]
        j-=1
for i in range(1,s+1):
    optim=t[i][1]
    for coin in coins:
        if t[i-coin][1]+1<optim: t[i]=[coin,t[i-coin][1]+1]
print('The coins are:',end=' ')
while s!=0:
    print(t[s][0],end=' ')
    s-=t[s][0]