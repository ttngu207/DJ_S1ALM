#!/usr/bin/env python
from setuptools import setup, find_packages
from os import path
import sys

here = path.abspath(path.dirname(__file__))

long_description = """"
Pipeline and ingestion routine for MAP's S1-ALM project.
This pipeline accompanies the publication: 
"""

with open(path.join(here, 'requirements.txt')) as f:
    requirements = f.read().splitlines()

setup(
    name='s1alm',
    version='0.0.1',
    description="Pipeline and ingestion routine for MAP's S1-ALM project",
    long_description=long_description,
    author='DataJoint NEURO',
    author_email='info@vathes.com',
    license='MIT',
    url='https://github.com/arsenyf/DJ_S1ALM',
    keywords='neuroscience electrophysiology datajoint',
    packages=find_packages(exclude=['contrib', 'docs', 'tests*']),
    entry_points={
        'console_scripts': [
            's1alm_ingest = pipeline_py.nwb_to_datajoint:main',
        ]
    },
    install_requires=requirements,
)