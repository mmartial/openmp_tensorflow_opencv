F# DockerFile with TensorFlow and OpenCV

Install an OpenMP optimized version of TensorFlow and OpenCV. Also install, Jupyter, Keras, numpy, pandas and X11 support.

## Docker images tag naming

The image tags follow the `tensorflow_opencv` naming order: `1.13.1_3.4.6` refers to *TensorFlow 1.13.1* and *OpenCV 3.4.6*.

Docker images also tagged with a version information for the date (YYYYMMDD) of the Dockerfile against which they were built from, added at the end of the tag string (following a dash character), such that `tensorflow_opencv:1.13.1_4.1.0-20190619` is for *Dockerfile dating June 19th, 2019*.

## Building the images

Use the provided `Makefile` to get a list of tags.
Use `make build_all` to build all containers.

## Using the container images

The use of the provided `runDocker.sh` script  present in the directory to test the built image; it will set up the X11 passthrough and give the use a prompt, as well as mount the calling directory as `/dmc`.The user can test X11 is functional by using a simple X command such as `xlogo` from the command line.

Note that the base container runs as root, if you want to run it as a non root user, add `-u $(id -u):$(id -g)` to the `docker` command line but ensure that you have access to the directories you will work in.

To use it, the full tag of the container image should be passed as the `CTO_TAG` environment variable. For example, to use `1.13.1_4.1.0-20190619`, run `CTO_TAG=1.13.1_4.1.0-20190605 ./runDocker.sh`. Note that `./` can be replaced by the location of `runDocker.sh` so that the user can mount its current working directory as `/dmc` in order to access local files.

For example, if the user place a picture (named `pic.jpg`) in the directory to be mount as `/dmc` and the following example script (naming it `display_pic.py3`)

    import numpy as np
    import cv2

    img = cv2.imread('pic.jpg')
    print(img.shape, " ", img.size)
    cv2.imshow('image', img)
    cv2.waitKey(0) & 0xFF
    cv2.destroyAllWindows()

, adapting "PATH_TO_RUNDOCKER" in `CTO_TAG=1.13.1_4.1.0-20190619 PATH_TO_RUNDOCKER/runDocker.sh`.
From the bash interactive shell, type `cd /dmc; python3 display_pic.py3` will display the picture on the user's X11 display.
