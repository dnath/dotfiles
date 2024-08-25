VENV_DIR="${HOME}/venv/.venv"
VENV_CONFIG_DIR="${HOME}/venv/config"

function setup_venv(){
	local venv_name=$1
	if [[ -z "${venv_name}" ]]; then
   		echo "venv name is not set!"
   		exit -1
	fi
	if [ -d "${VENV_DIR}/${venv_name}" ]; then
	 	echo "${VENV_DIR}/${venv_name} already exists."
	 	echo "Please delete with 'rm -rf ${VENV_DIR}/${venv_name}' if you want to start from scratch."
	 	exit -1
	fi

	cd ${VENV_DIR}

	if [ $? -ne 0 ]; then
		echo "Couldn't find ${VENV_DIR}!"
		exit -1
	fi

	python3 -m venv ${venv_name}

	source "${VENV_DIR}/${venv_name}/bin/activate"

	pip install -r "${VENV_CONFIG_DIR}/${venv_name}.requirements.txt"

	if [ $? -ne 0 ]; then
		echo "Setup unsuccessful .. cleaning up ${VENV_DIR}/${venv_name}."
		rm -rf "${VENV_DIR}/${venv_name}"
		exit -1
	fi
}