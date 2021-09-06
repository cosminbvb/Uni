from sklearn import preprocessing, svm
import numpy as np
from sklearn.metrics import accuracy_score, f1_score

# x_train = np.array([[1, -1, 2], [2, 0, 0], [0, 1, -1]], dtype=np.float64)
# x_test = np.array([[-1, 1, 0]], dtype=np.float64)
#
# # facem statisticile pe datele de antrenare
# scaler = preprocessing.StandardScaler()
# scaler.fit(x_train)
#
# # afisam media
# print(scaler.mean_) # => [1. 0. 0.33333333]
#
# # afisam deviatia standard
# print(scaler.scale_) # => [0.81649658 0.81649658 1.24721913]
#
# # scalam datele de antrenare
# scaled_x_train = scaler.transform(x_train)
# print(scaled_x_train) # => [[0. -1.22474487 1.33630621]
#                       # [1.22474487 0. -0.26726124]
#                       # [-1.22474487 1.22474487 -1.06904497]]
#
# # scalam datele de test
# scaled_x_test = scaler.transform(x_test)
# print(scaled_x_test) # => [[-2.44948974 1.22474487 -0.26726124]]

train_data = np.load('training_sentences.npy', allow_pickle = True)
train_labels = np.load('training_labels.npy')
test_data = np.load('test_sentences.npy', allow_pickle = True)
test_labels = np.load('test_labels.npy')

# 2
def normalize_data(train_data, test_data, type=None):
    if type == None:
        return train_data, test_data
    if type == 'standard':
        scaler = preprocessing.StandardScaler()
        scaler.fit(train_data)
        return scaler.transform(train_data), scaler.transform(test_data)
    if type == 'l1':
        normalizer = preprocessing.Normalizer(norm='l1')
        normalizer.fit(train_data)
        return normalizer.transform(train_data), normalizer.transform(test_data)
    if type == 'l2':
        normalizer = preprocessing.Normalizer(norm='l2')
        normalizer.fit(train_data)
        return normalizer.transform(train_data), normalizer.transform(test_data)

# 3, 4
class BagOfWords:
    def __init__(self):
        self.vocabulary = {}
        self.words = []

    def build_vocabulary(self, data):
        word_id = 0
        self.words = []
        for sentence in data:
            for word in sentence:
                if word not in self.vocabulary:
                    self.vocabulary[word] = word_id
                    word_id += 1
                    self.words.append(word)

    def words_size(self):
        return len(self.words)

    def get_features(self, data):
        s = np.zeros((len(data), len(self.vocabulary)))
        for i in range(len(data)):
            for j in data[i]:
                if j in self.vocabulary:
                    s[i, self.vocabulary[j]] += 1
        return s


bag_of_words = BagOfWords()
bag_of_words.build_vocabulary(train_data)
print(bag_of_words.words_size()) # 9522

# 5
train_features = bag_of_words.get_features(train_data)
test_features = bag_of_words.get_features(test_data)

train_features, test_features = normalize_data(train_features, test_features)

# 6
cls = svm.SVC(C = 1.0, kernel = 'linear')
cls.fit(train_features, train_labels)
predictions = cls.predict(test_features)
print(f"Accuracy: {accuracy_score(test_labels, predictions)}")
print(f"F1 score: {f1_score(test_labels, predictions)}")


