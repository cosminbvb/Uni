def MergeSort(list):
    if len(list)>1:
        mid=len(list)//2
        lefthalf=list[:mid]
        righthalf=list[mid:]
        MergeSort(lefthalf)
        MergeSort(righthalf)
        i=j=k=0
        while i<len(lefthalf) and j<len(righthalf):
            if lefthalf[i]<righthalf[j]:
                list[k]=lefthalf[i]
                i+=1
            else:
                list[k]=righthalf[j]
                j+=1
            k+=1
        while i<len(lefthalf):
            list[k]=lefthalf[i]
            i+=1
            k+=1
        while j<len(righthalf):
            list[k]=righthalf[j]
            j+=1
            k+=1