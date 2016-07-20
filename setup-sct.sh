#!/usr/bin/env bash
GR=0
VENV_ROOT='sct-venv'
run_rc() {
    echo "Running '$1'"
    eval $1
    if [ $? != 0 ]; then
        GR=1
    fi
}

if ! [ -e "${VENV_ROOT}/bin/activate" ]
then
    run_rc "virtualenv ${VENV_ROOT}"
fi
run_rc "source ${VENV_ROOT}/bin/activate"
run_rc "easy_install -U setuptools"
run_rc "pip install -r requirements.txt"
run_rc "pip install ."

if [ ${GR} -eq 0 ]
then
    echo "Scylla Cluster Tests successfully configured"
    echo "Now run 'source ${VENV_ROOT}/bin/activate' to work from the created virtual environment"
    if ! [ -e "${HOME}/.aws/credentials" ]
    then
        echo "Make sure you execute 'aws configure' to configure AWS"
        echo "Create a proper config file, see README.rst for more details"
    fi
else
    echo "An error was encountered during Scylla Cluster Tests setup"
    echo "Review the logs, fix problems and re-run this script"
fi
