def WeightedMedian(w): # where w is a list of tuples -> (value, weight)
    if len(w)==1:
        return w[0]
    if len(w)==2:
        if w[0][1]>w[1][1]:
            return w[0]
        return w[1]
    e=w[len(w)//2]
    ss=sd=0
    ws=wd=[]
    for x in w:
        if x[0]<e[0]:
            ss+=x[1]
            ws.append(x)
        if x[0]>e[0]:
            sd+=x[1]
            wd.append(x)
    if ss<0.5 and sd<=0.5:
        return e
    if ss>=0.5:
        e[1]+=sd
        ws.append(e)
        WeightedMedian(ws)
    if sd<0.5:
        e[1]+=ss
        wd.append(e)
        WeightedMedian(wd)
