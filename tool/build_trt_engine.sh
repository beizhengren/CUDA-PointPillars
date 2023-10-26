#!/bin/bash
/usr/src/tensorrt/bin/trtexec --onnx=./model/pfe.onnx --fp16 --builderOptimizationLevel=4 --saveEngine=./model/pfe.8611.opt4.plan --inputIOFormats=fp16:chw --outputIOFormats=fp16:chw --verbose --dumpLayerInfo --dumpProfile --separateProfileRun --profilingVerbosity=detailed > workspace/pfe.8611.opt4.log 2>&1
/usr/src/tensorrt/bin/trtexec --onnx=./model/backbone.onnx --fp16 --plugins=build/libpointpillar_core.so --saveEngine=./model/backbone.8611.plan --inputIOFormats=fp16:chw,int32:chw,int32:chw --verbose --dumpLayerInfo --dumpProfile --separateProfileRun --profilingVerbosity=detailed > workspace/backbone.8611.log 2>&1

# /usr/src/tensorrt/bin/trtexec --plugins=build/libpointpillar_core.so --loadEngine=./model/backbone.8611.plan --verbose > workspace/backbone.8611.run.log 2>&1
