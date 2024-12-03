# CNN for Image Classification

This project demonstrates the implementation of a Convolutional Neural Network (CNN) using TensorFlow and Keras for classifying images into four categories: cats, dogs, horses, and humans.

## Features
- **Data Loading and Preprocessing**: Handles image extraction, resizing, and normalization.
- **Model Architecture**: Implements a CNN with convolutional, pooling, dropout, and dense layers.
- **Model Training and Evaluation**: Includes cross-entropy loss calculation, accuracy tracking, and confusion matrix visualization.
- **Model Saving and Reloading**: Supports saving the architecture and weights for future use.

## Dataset
- The dataset consists of images categorized into:
  - Cats
  - Dogs
  - Horses
  - Humans
- Ensure the images are structured into subfolders, with one folder per category.

## Instructions

### Prerequisites
Install the required packages:
```bash
pip install numpy matplotlib tensorflow opencv-python

