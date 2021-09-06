import numpy as np
from PIL import Image
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt
from sklearn.neural_network import MLPClassifier
from sklearn.model_selection import RandomizedSearchCV

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

ss = StandardScaler()  # standardizam imaginile (pentru fiecare atribut se scade media si se imparte la std dev)
ss.fit(train_images)
train_images = ss.transform(train_images)
validation_images = ss.transform(validation_images)

# Incercam un RandomSearch:
mlp = MLPClassifier()
params = {
    'hidden_layer_sizes': [(1024, 9), (1024, 512, 9), (1024, 690, 690, 9)],
    'activation': ['tanh', 'relu', 'logistic'],
    'solver': ['sgd', 'adam'],
    'learning_rate_init': [0.0001, 0.001, 0.01, 0.1],
    'alpha': [0.0001, 0.05],
    'learning_rate': ['constant', 'adaptive'],
    'momentum':[0.9, 0.8]
}
search = RandomizedSearchCV(mlp, params, n_jobs=-1)  # n_jobs - se folosesc toate procesoarele
search.fit(train_images, train_labels)
print(search.best_params_)

# {'solver': 'adam', 'momentum': 0.8, 'learning_rate_init': 0.0001, 'learning_rate': 'constant', 'hidden_layer_sizes': (1024, 690, 690, 9), 'alpha': 0.05, 'activation': 'relu'}
mlp = MLPClassifier(solver = 'adam', learning_rate_init=0.0001, momentum=0.8,
                    hidden_layer_sizes = (1024, 690, 690, 9), learning_rate='constant',
                    alpha = 0.05, activation = 'relu')
mlp.fit(train_images, train_labels)
print(mlp.score(validation_images, validation_labels))
# 0.7746