import numpy as np
from PIL import Image
from sklearn.neighbors import KNeighborsClassifier
import matplotlib.pyplot as plt

# citire metadate:
train_metadata = np.genfromtxt('data/train.txt', delimiter = ',', dtype='U10,i')  # U10 = Unicode string, i = integer
validation_metadata = np.genfromtxt('data/validation.txt', delimiter = ',', dtype='U10,i')
test_metadata = np.genfromtxt('data/test.txt', dtype = 'str')

# initalizam array-ul de imagini si cel de label-uri
train_images = np.empty((len(train_metadata), 1024))
train_labels = np.empty(len(train_metadata))
for i, data in enumerate(train_metadata):
    # deschidem fiecare imagine de train, ii dam cast la numpy array si apoi reshape sub forma de vector cu 32x32=1024px
    img = np.asarray(Image.open('data/train/' + data[0])).reshape((1024, ))
    train_images[i] = img  # salvam imaginea in array
    train_labels[i] = data[1]  # salvam label-ul imaginii

# analog pentru validare si test
validation_images = np.empty((len(validation_metadata), 1024))
validation_labels = np.empty(len(validation_metadata))
for i, data in enumerate(validation_metadata):
    img = np.asarray(Image.open('data/validation/' + data[0])).reshape((1024, ))
    validation_images[i] = img
    validation_labels[i] = data[1]

test_images = np.empty((len(test_metadata), 1024))
for i, data in enumerate(test_metadata):
    img = np.asarray(Image.open('data/test/' + data)).reshape((1024, ))
    test_images[i] = img


scores = []  # aici salvam scorurile in functie de numarul de vecini
for i in range(1, 100, 1):
    clf = KNeighborsClassifier(n_neighbors=i, metric='euclidean')
    clf.fit(train_images, train_labels)
    score = clf.score(validation_images, validation_labels)
    scores.append(score)
    print(f"n = {i}, acc = {score}")

# cel mai bun scor => n = 9, acc = 0.4916

# construim graficul evolutiei scorului in functie de numarul de vecini
neighbors = [i for i in range(1, 100, 1)]
plt.plot(neighbors, scores)
plt.xlabel("Number of Neighbors")
plt.ylabel("Accuracy")
plt.show()
