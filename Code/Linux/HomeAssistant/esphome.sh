#!/bin/bash

pip3 install esphome
export PATH=$PATH:$HOME/.local/bin
esphome compile slzb-06-esphome-btproxy.yaml