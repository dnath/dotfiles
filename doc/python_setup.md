# Python Setup

## Install Pip

NOTE: `pip` is already installed if you are using Python 2 >=2.7.9 or Python 3 >=3.4 downloaded from python.org or if you are working in a Virtual Environment created by `virtualenv` or `venv`. Just make sure to upgrade pip.

For macOS:

```shell
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
rm -f get-pip.py
```

For linux:

```shell
sudo apt install python3-pip
```

### Upgrade pip

For linux / macOS:

```shell
pip3 install -U pip
```

Ref: <https://pip.pypa.io/en/stable/installing/>

## Interesting pip packages

### Powerline Status for Vim

```shell
pip3 install powerline-status
```

Ref: <https://github.com/powerline/powerline>

### numpy

```shell
pip3 install numpy
```

Ref: <https://numpy.org/install/>

### pandas

```shell
pip3 install pandas
```

Ref:

1. <https://pandas.pydata.org/docs/getting_started/install.html>
2. <https://pandas.pydata.org/getting_started.html>

## matplotlib

```shell
pip3 install -U pip
pip3 install -U matplotlib
```

Ref: <https://matplotlib.org/stable/users/installing.html#installing-an-official-release>

### Scikit-learn (sklearn)

```shell
pip3 install -U scikit-learn
```

Ref: <https://scikit-learn.org/stable/install.html>

### TensorFlow

```shell
# Requires the latest pip
pip3 install -U pip

# Current stable release for CPU and GPU
pip3 install tensorflow
```

Ref: <https://www.tensorflow.org/install>

### Keras

### Django

```shell
pip3 install Django==${VERSION}
```

Ref: <https://www.djangoproject.com/download/>

### Flask

```shell
pip3 install Flask
```

Ref: <https://flask.palletsprojects.com/en/1.1.x/installation/>
