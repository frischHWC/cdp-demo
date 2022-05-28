#!/usr/bin/env bash
# TODO : Change it according to your python path and which python version you want to use (or remove it if you want to use default python installed)
export PYSPARK_PYTHON=python
spark-submit \
    --class pyspark/App.py \
    --master yarn \
    --deploy-mode cluster \
    --principal "{{ kerb_user }}" \
    --keytab "{{ kerb_keytab }}" \
    --files pyspark/App.py \
    pyspark/App.py
