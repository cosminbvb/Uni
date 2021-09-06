from PIL import Image
import numpy as np
from skimage import io

# https://machinelearningmastery.com/how-to-manually-scale-image-pixel-data-for-deep-learning/

image = Image.open("images/bridge.png")
print(image.format)
print(image.mode)
print(image.size)
#image.show()

# Normalize pixel values

pixels = np.asarray(image)
pixels2 = pixels.copy()
pixels3 = pixels.copy()

# Afisare inainte de normalizare (pixeli intre 0-255)
io.imshow(pixels.astype(np.uint8))
io.show()

# confirm pixel range is 0-255
print('Data Type: %s' % pixels.dtype)
print('Min: %.3f, Max: %.3f' % (pixels.min(), pixels.max()))
# convert from integers to floats
pixels = pixels.astype('float32')
# normalize to the range 0-1
pixels /= 255.0
# confirm the normalization
print('Min: %.3f, Max: %.3f' % (pixels.min(), pixels.max()))

# Afisare dupa normalizare (pixeli intre 0-1)
io.imshow(pixels.astype(np.float32))
io.show()

'''
# Centering and then normalizing pixel values
print('Centrare:\n')
mean = pixels2.mean()
print('Mean: %.3f' % mean)
pixels2 = pixels2 - mean
mean = pixels2.mean()
print('Mean: %.3f' % mean)
print('Min: %.3f, Max: %.3f' % (pixels2.min(), pixels2.max()))

print('Normalizare:\n')
pixels2 /= pixels2.max()
print('Min: %.3f, Max: %.3f' % (pixels2.min(), pixels2.max()))
mean = pixels2.mean()
print('Mean: %.3f' % mean)

# Normalizing then centering pixel values
pixels3 = pixels3 / 255
mean = pixels3.mean()
pixels3 = pixels3 - mean
print('Min: %.3f, Max: %.3f' % (pixels3.min(), pixels3.max()))
'''

# convert from integers to floats
pixels2 = pixels2.astype('float32')
# calculate global mean and standard deviation
mean, std = pixels2.mean(), pixels2.std()
print('Mean: %.3f, Standard Deviation: %.3f' % (mean, std))
# global standardization of pixels
pixels2 = (pixels2 - mean) / std
# confirm it had the desired effect
mean, std = pixels2.mean(), pixels2.std()
print('Mean: %.3f, Standard Deviation: %.3f' % (mean, std))

io.imshow(pixels2.astype(np.float32))
io.show()
