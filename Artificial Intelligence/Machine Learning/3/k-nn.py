import numpy as np
import collections
import matplotlib.pyplot as plt

train_images = np.loadtxt('train_images.txt') # incarcam imaginile
train_labels = np.loadtxt('train_labels.txt').astype(int) # incarcam etichetele avand tipul de date int
test_images = np.loadtxt('test_images.txt')
test_labels = np.loadtxt('test_labels.txt').astype(int)

# print(train_images.shape) # (num_samples, num_features) = (1000, 784)

# 1 + 2
class KNNClassifier:
    def __init__(self, train_images, train_labels):
        self.train_images = train_images
        self.train_labels = train_labels

    def classify_image(self, test_image, num_neighbours = 3, metric = 'l2'):
        dist_array = self.train_images - test_image
        if metric == 'l1':
            dist_array = np.sum(np.abs(dist_array), axis=1)
            # vrem sa calculam distanta de la test_image la toate imaginile din train_images
            # deci pentru fiecare i, calculam |train_images[i] - test_image|
            # apoi, dupa ce avem avem un vector de vectori diferente (sunt vectori
            # de 784, nu matrici, pentru ca nu le-am dat reshape la 28x28)
            # calculam suma fiecarui vector (fiind vector de vectori, folosim axis = 1)
        if metric == 'l2':
            dist_array = np.sqrt(np.sum(np.power(dist_array, 2), axis=1))
            # aceeasi poveste si aici doar ca se calculeaza patratul fiecarei valori
            # din vectorul diferenta, apoi se face radical pe suma

        # in dist_array avem distantele de la test_image la fiecare imagine din train_images
        # trebuie sa le sortam, sa luam primele k = neighbours imagini (deci ne trebuie indexul
        # initial al imaginilor, dupa acestea au fost sortate, motiv pt care folosim argsort)
        # iar apoi cautam label urile acelori imagini. Alegem label-ul care apare de cele
        # mai multe ori in acele k imagini

        closest_k_images = np.argsort(dist_array)[:num_neighbours]
        closest_k_labels = self.train_labels[closest_k_images]

        # # for some reason cu chestia asta am obtinut 90.60000000000001:
        # frequency = collections.Counter(closest_k_labels)
        # best_label = max(frequency.keys(), key=(lambda key: frequency[key]))
        # return best_label
        # # collections.Counter(arr) intoarce un dictionar de forma valoare : frecventa
        # # iar apoi se face max pe itemele din dictionar si se returneaza cheia a carei valori e maxima

        best_label = np.argmax(np.bincount(closest_k_labels))
        return best_label

    def classify_images(self, test_images, num_neighbours = 3, metric = 'l2'):
        predictions = np.full(len(test_images), 0)
        for i, img in enumerate (test_images):
            prediction = knn.classify_image(img, num_neighbours, metric)
            predictions[i] = prediction
        return predictions

knn = KNNClassifier(train_images, train_labels)

img0 = test_images[0]
pred0 = knn.classify_image(img0)
plt.imshow(img0.reshape(28,28), cmap="gray")
plt.title(f'Classified as {pred0}')
plt.show()

# 3
predictions = knn.classify_images(test_images)
accuracy = (predictions == test_labels).mean()*100
print(f"3-NN, L2, MNIST Accuracy: {accuracy}%") # 89.8%

file = open("predictii_3nn_l2_mnist.txt", "w")
np.savetxt(file, predictions)
file.close()

# 4 a
file = open("acuratete_l2.txt", "w")
k_accuracies_l1 = []
k_accuracies_l2 = []
k_choices = [i for i in range(1, 10, 2)]
for k in k_choices:
    predictions_l1 = knn.classify_images(test_images, k, 'l1')
    predictions_l2 = knn.classify_images(test_images, k, 'l2')
    accuracy_l1 = (predictions_l1 == test_labels).mean()*100
    accuracy_l2 = (predictions_l2 == test_labels).mean()*100
    k_accuracies_l1.append(accuracy_l1)
    k_accuracies_l2.append(accuracy_l2)

np.savetxt(file,k_accuracies_l2)

plt.plot(k_choices, k_accuracies_l2)
plt.xlabel("number of neighbours")
plt.ylabel("accuracy")
plt.title("Accuracy with L2")
plt.show()

# 4 b
np.savetxt(file,k_accuracies_l1)
file.close()

plt.plot(k_choices, k_accuracies_l1)
plt.plot(k_choices, k_accuracies_l2)
plt.xlabel("number of neighbours")
plt.ylabel("accuracy")
plt.legend(['L1', 'L2'])
plt.show()


# # Reminder:
# x = np.array([[1,2,3,4],[4,5,6,7]])
# print(np.sum(x, axis = 0)) # [ 5  7  9 11]
# print(np.sum(x, axis = 1)) # [10 22]
# print(x.shape) # (2, 4) => 2 vectori de 4 elemente
# y = np.array([[[1,2],[3,4]],[[4,5],[6,7]]])
# print(y.shape) # (2, 2, 2) => 2 matrici de 2 pe 2