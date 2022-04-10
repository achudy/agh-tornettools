#!/bin/bash
python3 -m venv toolsenv
source toolsenv/bin/activate
export PATH="$HOME/.local/bin:$PATH"
pip install -r requirements.txt
shadow -h
tornettools -h 
oniontrace -h
tgentools -h
