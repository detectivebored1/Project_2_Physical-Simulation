# Project_2_Physical-Simulation
Teammates - egbus001, Jonathan Egbuson 
          - arkad004, Jacob Arkadie 

A cloth simulation physical model using Hooke's Law and Numerical Integration
Attempted features:

Multiple Ropes and 3D Simulation:
![](https://github.com/detectivebored1/Project_2_Physical-Simulation/blob/main/ClothSim_2022-10-21_20-52-54.gif)

Cloth Simulation:
![](https://github.com/detectivebored1/Project_2_Physical-Simulation/blob/main/ClothSim_2022-10-21_20-59-50.gif)

Tearing and User Interaction(through moving of sphere through arrow keys):
![](https://github.com/detectivebored1/Project_2_Physical-Simulation/blob/main/ClothSim_2022-10-21_20-37-33.gif)

Difficulties: The amount of artifacts remaining after a tear was very large, different cloth strands would stay stuck together. This was solved using a connection array that would indicate which points needed both to not be drawn and also not add a spring force.
The initial line of horizontal points would continue to stretch after interacting with any stopping force.
The circle used to simulate intersection would overlap the space between points and cross the textures. Creating a buffer radius helped the points not intersect the textures better.

Libraries: The orginal library written and the camera library provided by the teacher
