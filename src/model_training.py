import joblib
from sklearn.datasets import fetch_california_housing
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler

#  Fetch the Housing Data for California using sklearn datasets
housing = fetch_california_housing()

# Split the data into 80% train and 20% test
X_train, X_test, y_train, y_test = train_test_split(
    housing.data, housing.target, test_size=0.2, random_state=42
)

# Standardize and scale the train data.
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Model Fitting
model = RandomForestRegressor(n_estimators=100, random_state=42)
model.fit(X_train_scaled, y_train)

# Save the model into a pickle file
joblib.dump(model, "./models/housing_model.pkl")
print("Model trained and saved into housing_model.pkl in models file")
