# LeapMotionGestures
A MATLAB Toolbox that performs Gesture Recognition using the Leap Motion signals. </br>
The **demo** example is adapted to a Digit Recognition Application. It can classify an input sequence into a type of digit 0-9.

This repo contains:
- A small database of leap motion recorded digits
- A preprocessing module
- A feature extraction module
- A HMM based sequence classifier
- A GMM based sequence classifier
- A DTW based sequence classifier
- A fusion rule module 
 
 
 

## Preprocessing

To normalize data and ease recognition, we apply the following preprocessing pipeline

<p align="center">
  <img src='https://raw.githubusercontent.com/GMarzinotto/Leap-Motion-Gestures/master/demo/img/preprocessing_gesture.png'/>
</p>

## Sequence Classification

It allows training 3 different types of models for digit recognition:

- Hidden Markov Models (HMM)
- Gaussian Mixture Models (GMM)
- Dynamic Time Wraping (DTW)
 

### Hidden Markov Models (HMM)

<p align="center">
  <img src='https://raw.githubusercontent.com/GMarzinotto/Leap-Motion-Gestures/master/demo/img/hmm_hidden_states.png'/>
</p>

### Gaussian Mixture Models (GMM)

<p align="center">
  <img src='https://raw.githubusercontent.com/GMarzinotto/Leap-Motion-Gestures/master/demo/img/gmm_model_visual.png'/>
</p>

### Dynamic Time Wraping (DTW) + KNN 


<p align="center">
  <img src='https://raw.githubusercontent.com/GMarzinotto/Leap-Motion-Gestures/master/demo/img/dtw_projection_visual.png'/>
</p>


## Fusion Rule

Models outputs are combined to improve decisions

<p align="center">
  <img src='https://raw.githubusercontent.com/GMarzinotto/Leap-Motion-Gestures/master/demo/img/conf_matrix.png'/>
</p>




## External Dependencies

The repo has the following dependencies:

**DTW Library**: http://www.mathworks.com/matlabcentral/fileexchange/43156-dynamic-time-warping--dtw-

**HMM Library**: https://www.cs.ubc.ca/~murphyk/Software/HMM/hmm.html








