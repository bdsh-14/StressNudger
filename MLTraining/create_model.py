# create_model.py
import coremltools as ct
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import StandardScaler
import pandas as pd

# Create synthetic training data for demonstration
# In reality, you'd need labeled data from users
def generate_synthetic_data(n_samples=1000):
    np.random.seed(42)
    
    # Simulate "relaxed" scrolling
    relaxed_data = []
    for _ in range(n_samples // 2):
        relaxed_data.append([
            np.random.normal(100, 20),  # meanVelocity - moderate
            np.random.normal(30, 10),   # velocityStdDev - low variance
            np.random.normal(200, 40),  # maxVelocity
            np.random.normal(50, 15),   # jerkiness - low
            np.random.poisson(3),       # accelerationChanges - few
            np.random.poisson(1),       # scrollReversals - rare
            np.random.poisson(2),       # microPauses
            np.random.poisson(0.5),     # longPauses
            np.random.normal(8, 2),     # scrollDuration
            np.random.normal(15, 3),    # scrollFrequency
        ])
    
    # Simulate "stressed" scrolling
    stressed_data = []
    for _ in range(n_samples // 2):
        stressed_data.append([
            np.random.normal(180, 50),  # meanVelocity - higher & variable
            np.random.normal(80, 25),   # velocityStdDev - high variance
            np.random.normal(400, 100), # maxVelocity - spikes
            np.random.normal(150, 40),  # jerkiness - high
            np.random.poisson(8),       # accelerationChanges - many
            np.random.poisson(4),       # scrollReversals - frequent
            np.random.poisson(6),       # microPauses - many
            np.random.poisson(1),       # longPauses
            np.random.normal(8, 2),     # scrollDuration
            np.random.normal(25, 8),    # scrollFrequency - higher
        ])
    
    X = np.vstack([relaxed_data, stressed_data])
    y = np.hstack([np.zeros(n_samples // 2), np.ones(n_samples // 2)])
    
    return X, y

# Generate data
X, y = generate_synthetic_data()

# Train a simple model
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

clf = RandomForestClassifier(n_estimators=50, max_depth=5, random_state=42)
clf.fit(X_scaled, y)

# Convert to CoreML
feature_names = [
    "meanVelocity", "velocityStdDev", "maxVelocity",
    "jerkiness", "accelerationChanges", "scrollReversals",
    "microPauses", "longPauses", "scrollDuration", "scrollFrequency"
]

# Create CoreML model
coreml_model = ct.converters.sklearn.convert(
    clf,
    input_features=feature_names,
    output_feature_names="stressProbability"
)

# Add metadata
coreml_model.author = "StressNudger"
coreml_model.short_description = "Detects stress from scroll behavior"
coreml_model.input_description["meanVelocity"] = "Mean scroll velocity"
coreml_model.output_description["stressProbability"] = "Probability of stress (0-1)"

# Save
coreml_model.save("StressDetector.mlmodel")
print("Model saved successfully!")