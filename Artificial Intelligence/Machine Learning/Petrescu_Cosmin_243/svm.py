import numpy as np
from PIL import Image
from sklearn.svm import SVC
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


submission = open('data/submission.csv', 'w')
submission.write('id,label\n')

model = SVC(C=100.0, kernel='rbf')
model.fit(train_images, train_labels)
predictions = model.predict(test_images)

for i in range(len(predictions)):
    # id-ul imaginii si label-ul prezis
    submission.write(f'{test_metadata[i]},{int(predictions[i])}\n')
submission.close()

accuracy = model.score(validation_images, validation_labels)
print(f'Accuracy: {accuracy}')

# Scorurile pentru anumite configuratii:

# C=1.0, kernel='rbf' => Accuracy: 0.735
# C=10.0, kernel='rbf' => Accuracy: 0.7554
# C=50.0, kernel='rbf' => Accuracy: 0.7572
# C=100.0, kernel='rbf' => Accuracy: 0.7576
# C=200.0, kernel='rbf' => Accuracy: 0.7568

# C=1.0, kernel='poly' => Accuracy: 0.7134
# C=10.0, kernel='poly' => Accuracy: 0.708
# C=50.0, kernel='poly' => Accuracy: 0.7004
# C=100.0, kernel='poly' => Accuracy: 0.6958
# C=200.0, kernel='poly' => Accuracy: 0.6958

# Afisam un grafic cu evolutia scorului din incercarile de mai sus:
C = [1, 10, 50, 100, 200]
acc1 = [0.735, 0.7554, 0.7572, 0.7576, 0.7568]
acc2 = [0.7134, 0.708, 0.7004, 0.6958, 0.6958]
plt.scatter(C, acc1)  # scatter => se afiseaza puncte
plt.scatter(C, acc2)
plt.xlabel("C")
plt.ylabel("Score")
plt.legend(["Radial basis function Kernel", "Polynomial Kernel"])
plt.show()





