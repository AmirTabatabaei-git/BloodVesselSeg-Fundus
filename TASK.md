In this task, we will work on another type of medical image. The problem is to
segment blood vessels in fundus photography images. One example image, together with the blood
Vessel annotations are given below. For this task, we are free to make our own design. However, we
cannot use any techniques of deep learning.

After completing the implementation of our own design, run this algorithm on the three images that
are provided. For each image, compare the estimated vessel mask with the gold standard (stored in
a file called #_gold.png). Calculate the pixel-level precision, recall, and F-score metrics.

> *Note that in the #_gold.png files, foreground and background pixels are stored as 1 (not 255) and 0.
Thus, when you open it in an image editor, you will see almost a black image, not the one illustrated
below. To see the blood vessels, you need to visualize gold == 1.*

<p align="center">
  <img src="https://github.com/AmirTabatabaei-git/BloodVesselSeg-Fundus/assets/132440248/93c71d28-6641-4e20-b127-d06f7f0bc231">
</p>
