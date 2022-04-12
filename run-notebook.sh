#!/bin/bash
jupyter notebook --notebook-dir=/home/scd --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='123456' --NotebookApp.base_url='/datapipe-signalement-docelec'
