#!/bin/bash

export PATH=$PATH:/usr/local/cuda-8.0/bin

if uname | grep -q Darwin; then
  CUDA_LIB_DIR=/usr/local/cuda-8.0/lib64
elif uname | grep -q Linux; then
  CUDA_LIB_DIR=/usr/local/cuda-8.0/lib64
fi

nvcc -std=c++11 -O3 -o demo demo.cu -I/usr/local/cuda-8.0/include -L$CUDA_LIB_DIR -lcudart -lcublas -lcurand -D_MWAITXINTRIN_H_INCLUDED `pkg-config --cflags --libs opencv`









