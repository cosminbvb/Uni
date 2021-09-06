from mpl_toolkits import mplot3d
import numpy as np
import matplotlib.pyplot as plt

from sklearn.linear_model import Perceptron
from sklearn.neural_network import MLPClassifier
from sklearn.preprocessing import StandardScaler

perceptron_model = Perceptron(penalty=None, alpha=0.0001, fit_intercept=True,
                              max_iter=None, tol=None, shuffle=True, eta0=1.0,
                              early_stopping=False, validation_fraction=0.1,
                              n_iter_no_change=5)
# toti parametrii sunt optionali avand valori setate implicit

mlp_classifier_model = MLPClassifier(hidden_layer_sizes=(100, ), activation='relu',
                                     solver='adam', alpha=0.0001, batch_size='auto',
                                     learning_rate='constant', learning_rate_init=0.001,
                                     power_t=0.5, max_iter=200, shuffle=True,
                                     random_state=None, tol=0.0001, momentum=0.9,
                                     early_stopping=False, validation_fraction=0.1,
                                     n_iter_no_change=10)


# 1
x_train = np.loadtxt('3d-points/x_train.txt')
y_train = np.loadtxt('3d-points/y_train.txt')
x_test = np.loadtxt('3d-points/x_test.txt')
y_test = np.loadtxt('3d-points/y_test.txt')

perceptron = Perceptron(tol=1e-5, eta0=0.1, early_stopping=True)
perceptron.fit(x_train, y_train)
print(f'Score pe train: {perceptron.score(x_train, y_train)}')
print(f'Score pe test: {perceptron.score(x_test, y_test)}')
print(f'Ponderi: {perceptron.coef_[0]}')
print(f'Bias: {perceptron.intercept_}')
print(f'Nr epoci pana la convergenta: {perceptron.n_iter_}\n')


def plot3d_data_and_decision_function(X, y, W, b):
    ax = plt.axes(projection='3d')
    # create x,y
    xx, yy = np.meshgrid(range(10), range(10))
    # calculate corresponding z
    # [x, y, z] * [W[0], W[1], W[2]] + b = 0
    zz = (-W[0] * xx - W[1] * yy - b) / W[2]
    ax.plot_surface(xx, yy, zz, alpha=0.5)
    ax.scatter3D(X[y == -1, 0], X[y == -1, 1], X[y == -1, 2], 'b');
    ax.scatter3D(X[y == 1, 0], X[y == 1, 1], X[y == 1, 2], 'r');
    plt.show()


plot3d_data_and_decision_function(x_test, y_test, perceptron.coef_[0], perceptron.intercept_)

# 2
train_images = np.loadtxt('MNIST/train_images.txt')
train_labels = np.loadtxt('MNIST/train_labels.txt')
test_images = np.loadtxt('MNIST/test_images.txt')
test_labels = np.loadtxt('MNIST/test_labels.txt')

ss = StandardScaler()
ss.fit(train_images)
train_images = ss.transform(train_images)
test_images = ss.transform(test_images)


def train_and_test(mlp):
    mlp.fit(train_images, train_labels)
    print(mlp.score(test_images, test_labels))


# a
mlp1 = MLPClassifier(activation='tanh', hidden_layer_sizes=(1), learning_rate_init=0.01, momentum=0)
train_and_test(mlp1)

# b
mlp2 = MLPClassifier(activation='tanh', hidden_layer_sizes=(10), learning_rate_init=0.01, momentum=0)
train_and_test(mlp2)

# c
mlp3 = MLPClassifier(activation='tanh', hidden_layer_sizes=(10), learning_rate_init=0.00001, momentum=0)
train_and_test(mlp3)

# d
mlp4 = MLPClassifier(activation='tanh', hidden_layer_sizes=(10), learning_rate_init=10, momentum=0)
train_and_test(mlp4)

# e
mlp5 = MLPClassifier(activation='tanh', hidden_layer_sizes=(10), learning_rate_init=0.01, momentum=0, max_iter=20)
train_and_test(mlp5)

# f
mlp6 = MLPClassifier(activation='tanh', hidden_layer_sizes=(10, 10), learning_rate_init=0.01, momentum=0, max_iter=2000)
train_and_test(mlp6)

# g
mlp7 = MLPClassifier(activation='relu', hidden_layer_sizes=(10, 10), learning_rate_init=0.01, momentum=0, max_iter=2000)
train_and_test(mlp7)

# h
mlp8 = MLPClassifier(activation='relu', hidden_layer_sizes=(100, 100), learning_rate_init=0.01, momentum=0,
                     max_iter=2000)
train_and_test(mlp8)

# i
mlp9 = MLPClassifier(activation='relu', hidden_layer_sizes=(100, 100), learning_rate_init=0.01, momentum=0.9,
                     max_iter=2000)
train_and_test(mlp9)

# j
mlp10 = MLPClassifier(activation='relu', hidden_layer_sizes=(100, 100), learning_rate_init=0.01, momentum=0.9,
                      max_iter=2000, alpha=0.005)
train_and_test(mlp10)

