# Setting up python

Python is one of the two languages we use for most of our data analysis. You likely already have a version on your laptop, but it might be out of date and/or missing packages crucial for data analysis. To solve this, we use Anaconda, which manages python and its packages.

## Set up steps

1. Visit https://docs.anaconda.com/anaconda/install/ and select your operating system.
2. Select the most recent version of python supported by Anaconda. As of 3 April 2020, that's python 3.7.
3. Follow the steps on the installer.

If you are using a non-POSIX compliant shell such as `fish`, you will have to manually add anaconda into your path. (If you don't know what this means, don't worry about it.)

## jupyter

`jupyter` is an interactive interface for python, which we use for data exploration and prototyping code. It comes with Anaconda—you can just run `jupyter notebook` in a terminal and it'll show up.
