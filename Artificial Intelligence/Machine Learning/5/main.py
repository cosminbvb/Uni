import numpy as np
from sklearn.utils import shuffle
from sklearn.linear_model import LinearRegression, Ridge, Lasso
from sklearn import preprocessing
from sklearn.metrics import mean_squared_error, mean_absolute_error
from sklearn.model_selection import KFold

# definirea modelelor
# linear_regression_model = LinearRegression()
# ridge_regression_model = Ridge(alpha=1)
# lasso_regression_model = Lasso(alpha=1)

# # calcularea valorii MSE și MAE
# from sklearn.metrics import mean_squared_error, mean_absolute_error
# mse_value = mean_squared_error(y_true, y_pred)
# mae_value = mean_absolute_error(y_true, y_pred)

# load training data
training_data = np.load('data/training_data.npy')
prices = np.load('data/prices.npy')
# # print the first 4 samples
# print('The first 4 samples are:\n ', training_data[:4])
# print('The first 4 prices are:\n ', prices[:4])
# # shuffle
# training_data, prices = shuffle(training_data, prices, random_state=0)
#
# print(training_data.shape)

# 1
def normalize(train_data, test_data):
    scaler = preprocessing.StandardScaler()
    scaler.fit(train_data)
    return scaler.transform(train_data), scaler.transform(test_data)

# 2
def train_and_test(model, train_data, train_prices, test_data, test_prices):
    train_data, test_data = normalize(train_data, test_data)
    model.fit(train_data, train_prices)
    prediction = model.predict(test_data)
    mae = mean_absolute_error(test_prices, prediction)
    mse = mean_squared_error(test_prices, prediction)
    return mae, mse

n = len(training_data) // 3
data1, label1 = training_data[:n], prices[:n]
data2, label2 = training_data[n: 2 * n], prices[n:2 * n]
data3, label3 = training_data[2 * n:], prices[2 * n:]

linear_regression_model = LinearRegression()

mae1, mse1 = train_and_test(linear_regression_model, np.concatenate((data1, data2)), np.concatenate((label1, label2)), data3, label3)
mae2, mse2 = train_and_test(linear_regression_model, np.concatenate((data1, data3)), np.concatenate((label1, label3)), data2, label2)
mae3, mse3 = train_and_test(linear_regression_model, np.concatenate((data2, data3)), np.concatenate((label2, label3)), data1, label1)

print(f"MAE: {np.mean([mae1, mae2, mae3])}, MSE: {np.mean([mse1, mse2, mse3])}")

# 3
training_data, g = normalize(training_data, training_data)

kf = KFold(n_splits=3)
for alf in [1, 10, 100, 1000]:
    mae = []
    mse = []
    for train_index, test_index in kf.split(training_data):
        Xtrain = training_data[train_index]
        Xtest = training_data[test_index]
        ytrain = prices[train_index]
        ytest = prices[test_index]
        ridge_regression_model = Ridge(alpha=alf)
        ridge_regression_model.fit(Xtrain, ytrain)
        mse.append(mean_squared_error(ridge_regression_model.predict(Xtest), ytest))
        mae.append(mean_absolute_error(ridge_regression_model.predict(Xtest), ytest))
    print(alf)
    print(np.mean(mae))
    print(np.mean(mse))

# 4
ridge_regression_model = Ridge(alpha=10)
ridge_regression_model.fit(training_data, prices)
c = ridge_regression_model.coef_
b = ridge_regression_model.intercept_
h = np.abs(c).argsort()  # feature urile sunt ordonate dupa importanta
print(h)
print(b)