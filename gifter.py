#assembles png images into a gif
#may need to edit filenames directory, output dir, and the framerate variable below
#https://ezgif.com/optimize/ to compress gifs (typically by factor 50/200)

import imageio
import glob

framerate = 24 #img per sec

filenames=glob.glob("./output/*.png")
filenames.sort()

images = []
for filename in filenames:
    print(filename)
    images.append(imageio.imread(filename))
imageio.mimsave('./out.gif', images, fps=framerate)
