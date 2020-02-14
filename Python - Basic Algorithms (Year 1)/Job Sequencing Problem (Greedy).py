# input: id, deadline, income
f=open("jobs.txt")
v=[]
final=[]
maxdeadline=-1
for x in f.readlines():
    id=x.split()[0]
    deadline=int(x.split()[1])
    if maxdeadline<deadline: maxdeadline=deadline
    income=int(x.split()[2])
    v.append((id, deadline, income))
def sort(x):
    return x[2]
v.sort(key=sort,reverse=True)
i=0
j=1
while j<=maxdeadline:
    if v[i][1]>=j:
        final.append(v[i])
        i+=1; j+=1
    else:
        i+=1
str2="Ids: "
profit=0
for x in final:
    str2+=x[0]
    str2+=" "
    profit+=x[2]
str3="Total income: "+str(profit)
print(str2,str3)
'''
example:
a 2 100
b 1 19
c 2 27
d 1 25
e 3 15
=> Ids: a, c, e
=> Total income: 142
'''