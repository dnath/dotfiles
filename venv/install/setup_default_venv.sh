VENV_DIR="${HOME}/venv/.venv"
VENV_CONFIG_DIR="${HOME}/venv/config"

cd ${VENV_DIR}

if [ $? -ne 0 ]; then
	echo "Couldn't find ${VENV_DIR}!"
	exit -1
fi

DEFAULT_VENV='default-venv'
python3 -m venv ${DEFAULT_VENV}

source "${VENV_DIR}/${DEFAULT_VENV}/bin/activate"

pip install -r "${VENV_CONFIG_DIR}/default-venv.requirements.txt"
