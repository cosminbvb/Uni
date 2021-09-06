import numpy as np
import matplotlib.pyplot as plt
from sklearn.naive_bayes import MultinomialNB

train_images = np.loadtxt('train_images.txt') # incarcam imaginile
train_labels = np.loadtxt('train_labels.txt').astype(np.int) # incarcam etichetele avand tipul de date int
test_images = np.loadtxt('test_images.txt')
test_labels = np.loadtxt('test_labels.txt').astype(np.int)
#print(test_images[0].shape)
image = train_images[0, :] # prima imagine
image = np.reshape(image, (28,28)) # 1x784 => 28x28

# # Afisare imagine:
# plt.imshow(image.astype(np.uint8), cmap='gray')
# plt.show()

# Definirea modelului
naive_bayes_model = MultinomialNB()
# Antrenarea modelului
naive_bayes_model.fit(train_images, train_labels)
# Prezicerea etichetelor
naive_bayes_model.predict(test_images)
# Calcularea acuratetii
score = naive_bayes_model.score(test_images, test_labels)
print(score) # 0.846


# Exercitii:

# 1
train_dataset = [(160, 'F'), (165, 'F'), (155, 'F'), (172, 'F'), (175, 'B'), (180, 'B'), (177, 'B'), (190, 'B')]
# Dupa impartirea pe intervale avem:
# 150-160 2F 0B
# 161-170 1F 0B
# 171-180 1F 3B
# 181-190 0F 1B

# E exprimata gresit in enunt, ar trebui sa fie conditionata invers
# c = 3 ins ca apartine clasei de varsta 3 (171-180)
# P(c = 3 | x = B) = P(c = 3)*P(x = B | c = 3)/P(x = B) = 1/2*3/4 / 1/2 = 3/4 = 75%

# 2
def values_to_bins(matrix, interval):
    values_to_bins = np.digitize(matrix, interval) # ret pt fiecare elem intervalul corespunzator
    return values_to_bins - 1 # incepe de la 1, intrucat nu avem valori < 0

num_bins = 5 # aici e numarul de intervale (aka bins)
bins = np.linspace(0,255, num = num_bins) # returneaza intervalele
train_bins = values_to_bins(train_images, bins)
test_bins = values_to_bins(test_images, bins)
print(train_bins.max())
print(test_bins.max())

# 3
model2 = MultinomialNB()
model2.fit(train_bins, train_labels)
model2.predict(test_bins)
score2 = model2.score(test_bins, test_labels)
print(score2) # 0.836

# 4
for i in range(3, 12, 2):
    bins = np.linspace(0, 255, num = i)
    train = values_to_bins(train_images, bins)
    test = values_to_bins(test_images, bins)
    clasificator = MultinomialNB()
    clasificator.fit(train, train_labels)
    predicted = clasificator.predict(test)
    sc = clasificator.score(test, test_labels)
    print(f'Pentru num_bins = {i}, acuratetea este {sc}')
# Obs: daca presupunem ca avem un nr infinit de exemple in training dataset,
# atunci acuratetea ar creste odata cu cresterea numarului de bin uri, pentru
# ca asa creste si numarul de feature uri. Dar in cazul nostru nu e neaparat adevarat
# pentru ca avem doar n exemple in training

# 5
# Acuratetea cea mai mare a avut o i = 11 deci ramanem cu ultimul clasificator de la 3
indici_img_misclasate = np.where(test_labels != predicted)[0] # punem [0] pt a extrage din obiect lista efectiva
i = 0
while i<10:
    indice = indici_img_misclasate[i]
    img = train_images[indice, :]
    img = np.reshape(img, (28,28))
    plt.imshow(img.astype(np.uint8), cmap='gray')
    plt.title(f'Clasificata ca {predicted[indice]}')
    plt.show()
    i+=1

# 6
def confusion_matrix(y_true, y_pred):
    confusion = np.zeros((10,10))
    for i in range(len(y_true)):
        confusion[y_true[i], y_pred[i]] += 1
    return confusion
print(confusion_matrix(test_labels, predicted))