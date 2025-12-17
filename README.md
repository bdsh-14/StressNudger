# StressNudger

A privacy-first iOS research prototype exploring stress detection through passive behavioral sensing and physiological monitoring.

## Overview

StressNudger demonstrates on-device machine learning for real-time stress detection using scroll interaction patterns and heart rate data. The app captures behavioral metrics during natural smartphone use and uses CoreML for on-device inference without requiring data transmission.

**⚠️ Research Prototype Notice**: This is a proof-of-concept implementation using synthetic training data for demonstration purposes. Real-world deployment would require IRB-approved data collection with validated ground truth stress assessments.

## Technical Architecture

### 1. Multi-Modal Sensing
- **Behavioral Data**: Real-time scroll velocity, acceleration, jerkiness, reversals, and micro-pauses captured through custom SwiftUI scroll monitoring
- **Physiological Data**: Heart rate monitoring via HealthKit integration
- All sensor data processed locally with no network transmission

### 2. Feature Engineering
Extracts 10 behavioral features from scroll interactions:
- **Velocity statistics**: mean, standard deviation, maximum (indicators of erratic scrolling)
- **Jerkiness**: acceleration variance measuring smoothness of interaction
- **Behavioral patterns**: scroll reversals (indecisive behavior), micro-pauses (cognitive load indicators)
- **Temporal features**: scroll duration and frequency

### 3. On-Device ML Inference
- CoreML model trained on synthetic scroll-stress pattern data
- Real-time predictions every 2 seconds using 10-second sliding window
- Moving average smoothing to reduce false positives
- Stress threshold: 85% confidence for intervention triggering
- All processing on-device (privacy-preserving architecture)

### 4. Multi-Modal Fusion
- Combines scroll behavioral features with HealthKit heart rate data
- Weighted integration of behavioral patterns and physiological signals
- Fallback to behavioral-only detection when heart rate unavailable

### 5. Just-in-Time Intervention System
- Haptic feedback on stress detection (30-second cooldown to prevent alert fatigue)
- Guided breathing exercise with animated visual feedback
- Privacy-preserving (no data collection during interventions)

## Key Features

✅ **Complete privacy**: All data processing on-device, zero data transmission  
✅ **Multi-modal sensing**: Combines behavioral patterns with physiological data  
✅ **CoreML integration**: Real-time on-device machine learning inference  
✅ **HealthKit integration**: Heart rate monitoring for improved accuracy  
✅ **Minimal permissions**: Optional HealthKit access only  
✅ **Lightweight**: <1% CPU usage, minimal battery impact  
✅ **Research-ready**: Modular architecture for experimentation

## Research Motivation

Current mobile health sensing approaches face significant trade-offs:
- **Active sensing** (self-reports): High user burden, recall bias, compliance issues
- **Privacy-invasive sensing** (camera/microphone): User acceptance concerns, ethical considerations
- **Single-modal approaches**: Limited accuracy, context-dependent reliability

Passive multi-modal sensing from natural interactions offers potential for:
- Continuous, unobtrusive monitoring without explicit user input
- Privacy-preserving implementations using on-device processing
- Reduced user burden compared to ecological momentary assessment (EMA)
- Richer context through sensor fusion

### Research Questions This Work Explores

**1. Ground Truth Validation Challenge**
- How do we obtain reliable stress labels for passive sensing validation?
- Current approach uses synthetic data - real research requires validated stress assessment instruments (PSS-10, DASS-21, cortisol measures)
- What constitutes appropriate ground truth for momentary stress vs. chronic stress?

**2. Context-Aware Detection**
- Do scroll patterns differ when reading stressful content (news) vs. experiencing stress?
- How do we distinguish content-induced emotional responses from user stress states?
- What contextual features (app type, time of day, location) improve detection accuracy?

**3. Cross-User Generalization vs. Personalization**
- Do scroll-stress relationships transfer across users or require personalized models?
- What's the optimal balance between population-level and individual-level modeling?
- Can federated learning enable privacy-preserving personalization?

**4. Privacy-Accuracy Tradeoffs**
- What detection accuracy is achievable using only behavioral + basic physiological data?
- How does limiting sensor access (no camera/microphone/location) impact performance?
- Where is the boundary between useful detection and privacy invasion?

**5. Multi-Modal Sensor Fusion**
- How should behavioral and physiological signals be weighted for optimal prediction?
- What additional passive sensors (typing patterns, screen time, app usage) improve accuracy?
- When does adding sensors provide diminishing returns vs. increased privacy concerns?

## Screenshots
| Initial | Scrolling stress detection | High stress detection | Haptics & Breathing |
|:-:|:-:|:-:|:-:|
| <img width="250" height="550" alt="IMG_0844" src="https://github.com/user-attachments/assets/3574b925-252f-455d-961e-d5a6e4e1a2f0" /> | <img width="250" height="550" alt="IMG_0845" src="https://github.com/user-attachments/assets/34ea16fd-120c-409d-a72e-6c9ddd148b9f" /> | <img width="250" height="550" alt="IMG_0849" src="https://github.com/user-attachments/assets/ce4de2c2-1994-4482-9fc6-fe858cc9104f" /> | <img width="250" height="550" src="https://github.com/user-attachments/assets/6defe5e6-41ae-435f-999e-389940ecfb34" /> |


