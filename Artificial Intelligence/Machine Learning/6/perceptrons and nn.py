import numpy as np
import matplotlib.pyplot as plt
from sklearn.utils import shuffle
from sklearn.utils import shuffle

# 1
X = np.array([[0, 0], [0, 1], [1, 0], [1, 1]])
Y = np.array([-1, 1, 1, 1])

# 2
def compute_y(x, W, bias):
    # dreapta de decizie
    # [x, y] * [W[0], W[1]] + b = 0
    return (-x * W[0] - bias) / (W[1] + 1e-10)

def plot_decision_boundary(X, y , W, b, current_x, current_y):
    x1 = -0.5
    y1 = compute_y(x1, W, b)
    x2 = 0.5
    y2 = compute_y(x2, W, b)

    # sterge continutul ferestrei
    plt.clf()

    # ploteaza multimea de antrenare
    color = 'r'
    if(current_y == -1):
        color = 'b'
    plt.ylim((-1, 2))
    plt.xlim((-1, 2))
    plt.plot(X[y == -1, 0], X[y == -1, 1], 'b+')
    plt.plot(X[y == 1, 0], X[y == 1, 1], 'r+')

    # ploteaza exemplul curent
    plt.plot(current_x[0], current_x[1], color+'s')

    # afisarea dreptei de decizie
    plt.plot([x1, x2] ,[y1, y2], 'black')
    plt.show(block=False)
    plt.pause(0.3)

def perceptron(X, Y):
    # initializare ponderi + bias
    W = np.zeros(X.shape[1])
    b = 0
    epoch = 70
    lr = 0.1
    num_samples = X.shape[0]

    for e in range(epoch):
        X, Y = shuffle(X, Y)
        for t in range(num_samples):
            # calculare predictie
            y_hat = np.dot(X[t, :], W) + b

            # calculare eroare
            loss = ((y_hat - Y[t]) ** 2) / 2

            # actualizare ponderi
            W -= lr * (y_hat - Y[t]) * X[t, :]

            # actualizare bias
            b -= lr * (y_hat - Y[t])

            # plot_decision_boundary(X, Y, W, b, X[t, :], Y[t])
    return (np.sign(np.dot(X, W) + b) == Y).mean()

print(perceptron(X.copy(), Y.copy()))


# 3
Y = np.array([-1, 1, 1, -1])
print(perceptron(X.copy(), Y.copy()))


# 4
def plot_decision(X_, W_1, W_2, b_1, b_2):
    # sterge continutul ferestrei
    plt.clf()
    # ploteaza multimea de antrenare
    plt.ylim((-0.5, 1.5))
    plt.xlim((-0.5, 1.5))
    xx = np.random.normal(0, 1, (100000))
    yy = np.random.normal(0, 1, (100000))
    X = np.array([xx, yy]).transpose()
    X = np.concatenate((X, X_))
    _, _, _, output = forward_pass(X, W_1, b_1, W_2, b_2)
    y = np.squeeze(np.round(output))
    plt.plot(X[y == 0, 0], X[y == 0, 1], 'b+')
    plt.plot(X[y == 1, 0], X[y == 1, 1], 'r+')
    plt.show(block=False)
    plt.pause(0.1)

def sigmoid(x):
    return 1.0 / (1.0 + np.exp(-1.0 * x))

# derivata tanh
def tanh_derivative(x):
    return 1 - np.tanh(x) ** 2


def backward_pass(a_1, a_2, z_1, W_2, X, Y, num_samples):
    # start calculating the slope of the loss function with the respect to z
    dz_2 = a_2 - y

    # then, with respect to our weights and biases
    dw_2 = (1 / num_samples) * np.dot(a_1.T, dz_2)
    db_2 = (1 / num_samples) * np.sum(dz_2, axis=0)
    da_1 = np.dot(dz_2, W_2.T)
    dz_1 = np.multiply(da_1, tanh_derivative(z_1))
    dw_1 = (1 / num_samples) * np.dot(X.T, dz_1)
    db_1 = (1 / num_samples) * np.sum(dz_1, axis=0)

    return dw_1, db_1, dw_2, db_2


def forward_pass(X, W_1, b_1, W_2, b_2):
    # linear step
    z_1 = X.dot(W_1) + b_1
    # activation tanh
    a_1 = np.tanh(z_1)

    # second linear step
    z_2 = a_1.dot(W_2) + b_2
    # activation sigmoid
    a_2 = sigmoid(z_2)

    # return all values
    return z_1, a_1, z_2, a_2


# training set
X = np.array([
    [0, 0],
    [0, 1],
    [1, 0],
    [1, 1]])
# labels
y = np.expand_dims(np.array([0, 1, 1, 0]), 1)

# one hidden layer with tanh as activation function
# one neuron in the output layer with sigmoid
num_hidden_neurons = 5
num_output_neurons = 1
W_1 = np.random.normal(0, 1, (2, num_hidden_neurons))  # weights initilization
b_1 = np.zeros((num_hidden_neurons))
W_2 = np.random.normal(0, 1, (num_hidden_neurons, num_output_neurons))  # weights initilization
b_2 = np.zeros((num_output_neurons))

num_samples = X.shape[0]

num_epochs = 70
lr = 0.5
for e in range(num_epochs):
    X, y = shuffle(X, y)
    # forward
    z_1, a_1, z_2, a_2 = forward_pass(X, W_1, b_1, W_2, b_2)
    loss = -(y * np.log(a_2) + (1 - y) * np.log(1 - a_2)).mean()
    acc = (np.round(a_2) == y).mean()
    print('epoch: {} loss: {} accuracy: {}'.format(e, loss, acc))
    plot_decision(X, W_1, W_2, b_1, b_2)
    dw_1, db_1, dw_2, db_2 = backward_pass(a_1, a_2, z_1, W_2, X, y, num_samples)
    W_1 -= lr * dw_1
    b_1 -= lr * db_1
    W_2 -= lr * dw_2
    b_2 -= lr * db_2


# o incercare esuata (varianta de sus e buna):
# class NeuralNetwork:
#     def __init__(self):
#         self.epoch = 70
#         self.lr = 0.5
#         self.num_hidden_neurons = 5
#
#         # initializare ponderi + bias
#         self.W_1 = np.random.normal(0, 1, (self.num_hidden_neurons, 2))
#         self.b_1 = np.zeros((self.num_hidden_neurons, 1))
#         self.W_2 = np.random.normal(0, 1, (1, self.num_hidden_neurons))
#         self.b_2 = np.zeros((1, 1))
#
#     def sigmoid(self, Z):
#         return 1 / (1 + np.exp((-1) * Z))
#
#     def tanh_derivative(self, Z):
#         return 1.0 - np.tanh(Z) ** 2
#
#     def forward(self, X):
#         # strat 1
#         z_1 = self.W_1.dot(X.T) + self.b_1
#         a_1 = np.tanh(z_1)
#
#         # strat 2
#         z_2 = self.W_2.dot(a_1) + self.b_2
#         a_2 = self.sigmoid(z_2)
#
#         return z_1, a_1, z_2, a_2
#
#     def backward(self, X, Y, num_samples, a_1, a_2, z_1, z_2):
#         # al doilea strat
#         # derivata functiei de pierdere (logistic loss) in functie de z
#         dz_2 = a_2 - Y
#
#         # der(L/w_2) = der(L/z_2) * der(dz_2/w_2) = dz_2 * der((a_1 * W_2+ b_2) / W_2)
#         dw_2 = dz_2.dot(a_1.T) / num_samples
#
#         # der(L/b_2) = der(L/z_2) * der(z_2/b_2) = dz_2 * der((a_1 * W_2 +b_2) / b_2)
#         db_2 = np.sum(dz_2) / num_samples
#
#         # primul strat
#         # der(L/a_1) = der(L/z_2) * der(z_2/a_1) = dz_2 * der((a_1 * W_2 +b_2) / a_1)
#         da_1 = self.W_2.T.dot(dz_2)
#
#         # der(L/z_1) = der(L/a_1) * der(a_1/z1) = da_1 .* der((tanh(z_1))/z_1)
#         dz_1 = da_1 * self.tanh_derivative(z_1)
#
#         # der(L/w_1) = der(L/z_1) * der(z_1/w_1) = dz_1 * der((X * W_1 +b_1) / W_1)
#         dw_1 = dz_1.dot(X) / num_samples
#
#         # der(L/b_1) = der(L/z_1) * der(z_1/b_1) = dz_1 * der((X * W_1 +b_1) / b_1)
#         db_1 = np.sum(dz_1) / num_samples
#
#         return dw_1, db_1, dw_2, db_2
#
#     def compute_y(self, x, W, bias):
#         # dreapta de decizie
#         # [x, y] * [W[0], W[1]] + b = 0
#         return (-x * W[0] - bias) / (W[1] + 1e-10)
#
#     def plot_decision(self, X_):
#         # sterge continutul ferestrei
#         plt.clf()
#
#         # ploteaza multimea de antrenare
#         plt.ylim((-0.5, 1.5))
#         plt.xlim((-0.5, 1.5))
#         xx = np.random.normal(0, 1, (100000))
#         yy = np.random.normal(0, 1, (100000))
#         X = np.array([xx, yy]).transpose()
#         X = np.concatenate((X, X_))
#         _, _, _, output = self.forward(X)
#         y = np.squeeze(np.round(output))
#         plt.plot(X[y == 0, 0], X[y == 0, 1], 'b+')
#         plt.plot(X[y == 1, 0], X[y == 1, 1], 'r+')
#         plt.show(block=False)
#         plt.pause(0.1)
#
#     def train(self, X, Y):
#         for e in range(self.epoch):
#             X, Y = shuffle(X, Y)
#             z1, a1, z2, a2 = self.forward(X)
#
#             # pierdere + acuratete
#             loss = (-Y * np.log(a2) - (1 - Y) * np.log(1 - a2)).mean()
#             accuracy = (np.round(a2) == Y).mean()
#             print("loss: " + str(loss) + " accuracy: " + str(accuracy))
#
#             self.plot_decision(X)
#
#             # actualizare parametrii
#             dw1, db1, dw2, db2 = self.backward(X, Y, X.shape[0], a1, a2, z1, z2)
#             self.W_1 -= self.lr * dw1
#             self.b_1 -= self.lr * db1
#             self.W_2 -= self.lr * dw2
#             self.b_2 -= self.lr * db2
#
# X = np.array([[0, 0], [0, 1], [1, 0], [1, 1]])
# Y = np.array([-1, 1, 1, -1])
# NN = NeuralNetwork()
# NN.train(X, Y)