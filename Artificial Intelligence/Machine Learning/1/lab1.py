import numpy as np
import matplotlib.pyplot as plt
from skimage import io

y = np.array([[[1, 2, 3, 4], [5, 6, 7, 8]], [[1, 2, 3, 4], [5, 6, 7, 8]], [[1, 2, 3, 4], [5, 6, 7, 8]]])
print(y.shape)      # => (3, 2, 4)
print(y)            # => [[[1 2 3 4]
                    #      [5 6 7 8]]
                    #     [[1 2 3 4]
                    #      [5 6 7 8]]
                    #     [[1 2 3 4]
                    #      [5 6 7 8]]]

print(np.mean(y, axis=0))       # => [[1. 2. 3. 4.]
                                #     [5. 6. 7. 8.]]

print(np.mean(y, axis=1))       # => [[3. 4. 5. 6.]
                                #     [3. 4. 5. 6.]
                                #     [3. 4. 5. 6.]]
print(np.mean(y, axis=2))       # => [[2.5 6.5]
                                #     [2.5 6.5]
                                #     [2.5 6.5]]

print(np.sum(y, axis = 0))      # => [[ 3  6  9 12]
                                #     [15 18 21 24]]

print(np.sum(y, axis = 1))      # => [[ 6  8 10 12]
                                #     [ 6  8 10 12]
                                #     [ 6  8 10 12]]

print(np.sum(y, axis = 2))      # => [[10 26]
                                #     [10 26]
                                #     [10 26]]

print(np.sum(y, axis = (1,2)))  # => [36 36 36]


# a
images = np.zeros((9, 400, 600))
for i in range (9):
    image = np.load(f"images/car_{i}.npy")
    images[i] = image

# b
print(f"Suma totala a pixelilor = {images.sum()}")

# c
for i in range (9):
    print(f"Suma pixelilor - car_{i}.npy = {images[i].sum()}")

# d
print(f"Imaginea car_{np.argmax(np.sum(images, axis = (1,2)))}.npy are suma maxima")

# e
img_medie = np.mean(images, axis = 0)
io.imshow(img_medie.astype(np.uint8))   # petru a putea fi afisata
                                        # imaginea trebuie sa aiba
                                        # tipul unsigned int
io.show()

# f (aici nu am inteles daca per imagine sau nu, daca nu atunci e fara axis)
dev_std = np.std(images, axis = (1,2))
print(f"Deviatia standard = {dev_std}")

# deci pentru fiecare imagine calculam deviatia standard
# sa zicem ca avem imaginea x => deviatia std = sqrt(media(x^2)-media^2(x)), dar x^2 nu e ridicarea la patrat clasica de
# matrici, se ridica efectiv fiecare element la patrat


# g (am facut ca in cerinta desi nu stiu daca e bine)
normalized = np.copy(images)
for i in range(9):
    normalized[i] = np.subtract(normalized[i], img_medie) / dev_std[i]
    io.imshow(normalized[i].astype(np.uint8))
    io.show()

# h
for i in range (9):
    io.imshow(images[i][200:301, 280:401].astype(np.uint8))
    io.show()

