## Research Motivation

This prototype explores the **feasibility** of stress detection from scroll behavior 
as a stepping stone toward understanding limitations in passive mobile health sensing.

### What This Demonstrates:
- Technical capability to capture and process behavioral data in real-time
- Privacy-preserving architecture (all processing on-device)
- Understanding of feature engineering for behavioral pattern recognition
- Identification of key research challenges in passive sensing

### Why Not CoreML/HealthKit in This Version?

**CoreML**: Requires labeled training data (scroll patterns + validated stress assessments). 
Without IRB approval and participant recruitment, the current heuristic approach honestly 
represents the state of knowledge about scroll-stress relationships.

**HealthKit**: Future integration would enable multi-modal sensing (scroll + heart rate + 
sleep patterns) for improved accuracy. This prototype intentionally starts with the 
minimal viable sensor to understand baseline capabilities.

### Research Questions This Work Surfaced:

1. **Ground Truth Problem**: How do we collect scroll data with validated stress labels?
2. **Context Dependency**: Does scrolling through news produce different patterns than 
   social media, even at equivalent stress levels?
3. **Generalization**: Do scroll-stress patterns transfer across users or require 
   personalized models?
4. **Privacy-Accuracy Tradeoff**: What detection accuracy is achievable with only 
   on-device, non-identifiable behavioral data?

### Future Directions:

- Multi-modal integration (scroll + typing patterns + screen time)
- Federated learning for privacy-preserving personalization
- Validation study comparing passive sensing against validated instruments (PSS-10, DASS-21)
- Context-aware models that account for content being consumed
