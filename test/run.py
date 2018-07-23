#!/usr/bin/env python
"""
Here is a example of evaluate model script
Some variables or steps need for CI, so please dont change it
"""

import argparse
import json
import glob
import os

from model import TemplateModel

# Need for CI, please dont change 
DATA_DIR = os.environ.get('DATA_DIR', '/data') # default directory store data files
MODEL_DIR = os.environ.get('MODEL_DIR', '/model') # default directory store model files
REPORT_DIR = os.environ.get('REPORT_DIR', '/report') # default directory store report files

# Example of load model and evaluate. You can change it
MODEL_NAME = "TemplateModel"
parser = argparse.ArgumentParser()
parser.add_argument('--model_weight')
parser.add_argument('--model_label')
parser.add_argument('--dataset', action='append')
args = parser.parse_args()

model = TemplateModel()
model_weight = os.path.join(MODEL_DIR, args.model_weight)
model_label = os.path.join(MODEL_DIR, args.model_label)
model.load_model(weight=model_weight, label=model_label)
acc_data = {}
for dataset in args.dataset:
    acc = 1.0
    dataset_dir = os.path.join(DATA_DIR, dataset)
    label_file = os.path.join(dataset_dir, 'label.json')
    with open(label_file) as f:
        label_data = json.load(f)
    for file_name, answer in label_data.items():
        file_path = os.path.join(dataset_dir, file_name)
        result = model.predict(file_path)
        if result == answer:
            print()
    acc_data[dataset] = acc

# Need for CI, please dont change
report_file = os.path.join(REPORT_DIR, '{}_report.txt'.format(MODEL_NAME))
with open(report_file, 'a') as f:
    for dataset, acc in acc_data:
        f.write('{} {}\n'.format(dataset, acc))
