# 5611_PinballSim
Nae Olson Pinball Simluation project for class 5611 at the University of Minnesota

Email: olso9261@umn.edu

SimImage1.png: ![Alt](/SimImage1.png "Image")
SimImage2.png: ![Alt](/SimImage2.png "Image")


https://media.github.umn.edu/user/25193/files/66d80488-7175-4dac-ab1e-024884a4bb03

## FEATURES AND TIMESTAMPS
Showcase of features found in Nae_Video_Submission.mp4. Timestamps for each feature found below

---

* Basic Pinball Dynamics <mark>0:33</mark>
* Multiple Balls Inteeracting 0:52
* Circular Obstacles 1:10
* Line-Segment Obstacles 1:19
* Reactive Obstacle 1:40
* Multiple Material Types 1:51
* Score Display 2:04 (scoring mechanics - 2:30)
* Particle System Effects 2:41
* Loading Scenes from Files 2:56 (changing layouts 3:14) (layout2 3:22) (file setup 3:30)

* NOT SCORED: Scaleable!! (3:58)

## DIFFICULTIES
A primary difficulty I encountered was with how I planned out my code. I did not write the code in the cleanest fashion, and spent a lot of time scrolling through the main file looking for snippets, or sifting through algorthims that probably could have been repeated through a function (reading in objects with the InputParser, mainly). I spent a lot of time staring at lines trying to figure out where I was.

Additionallly, I had a lot of issues with proper line-ball collisions. Frequently, a ball would hit a line, and depending on the side of the line it hit, interact normally or jitter through it. I solved this issue lazily, by moving the balls along the normal of the line (reflected if hitting the line from bellow) so that it couldn't end up inside the line still after a frame, which is what I believe was causing the issue. This could have also been solved with coninuous collisiion detection, but I wanted to see if I could implement my lazy solution before moving to a more sound, though difficult, one.

## CODE USED
Most of the code is my own. The ParticleSystem generator was based off the simple particle system exercise in class, though heavily modified to generate the effect I wanted (an explosion). Additionally, the collision code based off my Homework 1 submission was modified to use arrays of vectors for objects instead of object classes, which were much slower to compute.

No third party libraries were used.
