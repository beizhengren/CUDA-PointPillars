#!/bin/bash
trtexec8_6="/home/wyz/workspace/softwares/Nvidia/TensorRT-8.6.1.6.Linux.x86_64-gnu.cuda-11.8/TensorRT-8.6.1.6/bin/trtexec"
trtexec8_4="/home/wyz/workspace/softwares/Nvidia/TensorRT-8.4.3.1/bin/trtexec"
trtexec=${trtexec8_4}
echo "trtexec: ${trtexec}"
${trtexec} --onnx=./model/pointpillar.onnx --fp16 --plugins=build/libpointpillar_core.so --saveEngine=./model/pointpillar.plan --inputIOFormats=fp16:chw,int32:chw,int32:chw --verbose --dumpLayerInfo --dumpProfile --separateProfileRun --profilingVerbosity=detailed > model/pointpillar.8611.log 2>&1
