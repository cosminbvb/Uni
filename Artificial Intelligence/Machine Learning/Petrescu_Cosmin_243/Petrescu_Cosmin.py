import numpy as np
from PIL import Image

from sklearn.metrics import confusion_matrix

from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout, Activation
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, LeakyReLU, BatchNormalization
from tensorflow.keras.losses import categorical_crossentropy
from tensorflow.keras.utils import to_categorical
from tensorflow.keras.optimizers import Adam, SGD

train_metadata = np.genfromtxt('data/train.txt', delimiter = ',', dtype='U10,i')
validation_metadata = np.genfromtxt('data/validation.txt', delimiter = ',', dtype='U10,i')
test_metadata = np.genfromtxt('data/test.txt', dtype = 'str')

train_images = np.empty((len(train_metadata), 32, 32, 1))
train_labels = np.empty(len(train_metadata))
for i, data in enumerate(train_metadata):
    img = np.asarray(Image.open('data/train/' + data[0])).reshape((32, 32, 1))
    # imaginile trebuie sa fie de forma latime, inaltime, numarul de canale de culoare
    train_images[i] = img
    train_labels[i] = data[1]

validation_images = np.empty((len(validation_metadata), 32, 32, 1))
validation_labels = np.empty(len(validation_metadata))
for i, data in enumerate(validation_metadata):
    img = np.asarray(Image.open('data/validation/' + data[0])).reshape((32, 32, 1))
    validation_images[i] = img
    validation_labels[i] = data[1]

test_images = np.empty((len(test_metadata), 32, 32, 1))
for i, data in enumerate(test_metadata):
    img = np.asarray(Image.open('data/test/' + data)).reshape((32, 32, 1))
    test_images[i] = img


# one hot encoding:
train_labels = to_categorical(train_labels)
validation_labels = to_categorical(validation_labels)

# normalizare:
train_images /= 255
validation_images /= 255
test_images /= 255

batch_size = 512
nr_epochs = 30

cnn = Sequential()
cnn.add(Conv2D(32, kernel_size=(3, 3), input_shape=(32, 32, 1), padding='same'))
# (https://keras.io/api/layers/convolution_layers/convolution2d/)
# cand se foloseste Conv2D ca prim layer, e nevoie de parametrul input_shape
# kenel_size - height and width of the 2d convolutional window
# padding = same - se aplica padding egal pe toate laturile inputului a.i. outputul sa aiba aceleasi dimensiuni
# padding = valid - fara padding
cnn.add(LeakyReLU())
cnn.add(Conv2D(64, (3, 3), padding='same'))
cnn.add(BatchNormalization())  # explicat in documentatie
cnn.add(LeakyReLU())
cnn.add(MaxPooling2D((2, 2), padding='same'))
cnn.add(Conv2D(64, (4, 4), padding='same'))
cnn.add(BatchNormalization())
cnn.add(LeakyReLU())
cnn.add(Conv2D(128, (4, 4), padding='same'))
cnn.add(BatchNormalization())
cnn.add(LeakyReLU())
cnn.add(MaxPooling2D((2, 2), padding='same'))
cnn.add(Conv2D(128, (3, 3), padding='same'))
cnn.add(BatchNormalization())
cnn.add(LeakyReLU())
cnn.add(Flatten())
cnn.add(Dense(128))
cnn.add(LeakyReLU())
cnn.add(Dense(9, activation='softmax'))

cnn.compile(loss=categorical_crossentropy, optimizer=Adam(), metrics=['accuracy'])
# Cross-entropy is the default loss function to use for multi-class classification problems.
cnn.summary()
cnn_train = cnn.fit(train_images, train_labels, batch_size=batch_size, epochs=nr_epochs,
                    verbose=1, validation_data=(validation_images, validation_labels))

cnn_predictions = np.argmax(cnn.predict(test_images), axis=-1)

validation_labels = np.argmax(validation_labels, axis=1)
confusion = confusion_matrix(validation_labels, np.argmax(cnn.predict(validation_images), axis=-1), labels=[0,1,2,3,4,5,6,7,8])
print(confusion)

submission = open('data/submission.csv', 'w')
submission.write('id,label\n')
for i in range(len(cnn_predictions)):
    submission.write(f'{test_metadata[i]},{int(cnn_predictions[i])}\n')
submission.close()
