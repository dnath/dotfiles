# Python Setup

## Install Pip

`pip` is already installed if you are using Python 2 >=2.7.9 or Python 3 >=3.4 downloaded from python.org or if you are working in a Virtual Environment created by `virtualenv` or `venv`. Just make sure to upgrade pip.

If using without a virtual enviroment, you may need to use `pip3` rather than `pip`.

To upgrade pip:

```shell
pip install -U pip
```

### For cases where we need to install `pip`

For macOS:

```shell
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
rm -f get-pip.py
```

For linux:

```shell
sudo apt install --assume-yes python3-pip
```

Ref: <https://pip.pypa.io/en/stable/installing/>

## Setting up `venv` environments

* To install, use one of the installation scripts in `venv/install/`

  Example:

  ```shell
  ${REPO}/venv/install/setup_jupyter_venv.sh
  ```

* To activate:
  
  ```shell
  source ${HOME}/venv/.venv/${ENV}/bin/activate
  ```

* To deactivate:
  
  ```shell
  deactivate
  ```

* To delete simply deactivate and delete the `venv` dir.

Ref: <https://python.land/virtual-environments/virtualenv>

## Useful pip packages

### Some essentials

```shell
pip install numpy pandas matplotlib plotly
```

### For ipython notebooks

```shell
pip install ipykernel itables
```

### Web serving frameworks

```shell
pip install fastapi Flask
```

### ML libraries

```shell
pip install scikit-learn tensorflow keras
pip install torch torchvision
```

### Status Line for Vim

```shell
pip install powerline-status
```

Ref: <https://github.com/powerline/powerline>