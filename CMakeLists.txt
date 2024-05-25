# SPDX-FileCopyrightText: Copyright (c) 2021 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cmake_minimum_required(VERSION 3.17)
project(pointpillar)
set(CMAKE_BUILD_PYTHON $ENV{USE_Python})
set(CMAKE_BUILD_TYPE "Release")

set(CMAKE_CXX_FLAGS_RELEASE "-std=c++17 -Wextra -Wall -Wno-missing-field-initializers -Wno-deprecated-declarations -O3")
set(CMAKE_CXX_FLAGS_DEBUG   "-std=c++17 -O0 -g")
# set(CMAKE_BUILD_TYPE "Debug")

set(arch ${CMAKE_HOST_SYSTEM_PROCESSOR}) # x86_64
if(${CMAKE_HOST_SYSTEM_PROCESSOR} STREQUAL  "aarch64")
  set(CMAKE_C_COMPILER /usr/bin/aarch64-linux-gnu-gcc)
  set(CMAKE_CXX_COMPILER /usr/bin/aarch64-linux-gnu-g++)
  set(CUDA_INSTALL_TARGET_DIR targets/aarch64-linux)
elseif(${CMAKE_HOST_SYSTEM_PROCESSOR} STREQUAL "x86_64")
  set(CMAKE_C_COMPILER /usr/bin/gcc)
  set(CMAKE_CXX_COMPILER /usr/bin/g++)
  set(CUDA_INSTALL_TARGET_DIR targets/x86_64-linux)
endif()

find_package(CUDA REQUIRED)
set(CUDA_TOOLKIT_ROOT_DIR /usr/local/cuda)
set(CUDA_INCLUDE_DIRS ${CUDA_TOOLKIT_ROOT_DIR}/${CUDA_INSTALL_TARGET_DIR}/include)
set(CUDA_NVCC_FLAGS_RELEASE "-Werror=all-warnings -Xcompiler -std=c++17,-Wextra,-Wall,-Wno-deprecated-declarations,-O3")
set(CUDA_NVCC_FLAGS_DEBUG   "-std=c++17 -O0 -g")

set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS} 
    -gencode arch=compute_86,code=compute_86
)

# set(TENSORRT_ROOT /home/wyz/workspace/softwares/Nvidia/TensorRT-8.4.3.1)
set(TENSORRT_ROOT /home/wyz/workspace/softwares/Nvidia/TensorRT-8.6.1.6.Linux.x86_64-gnu.cuda-11.8/TensorRT-8.6.1.6/)
set(TENSORRT_INCLUDE_DIRS ${TENSORRT_ROOT}/include/)
set(TENSORRT_LIBRARY_DIRS ${TENSORRT_ROOT}/lib/)

include_directories(
  ${CUDA_INCLUDE_DIRS}
  ${TENSORRT_INCLUDE_DIRS}
  src
	src/pointpillar
)

link_directories(
    ${TENSORRT_LIBRARY_DIRS}
    build)

file(GLOB_RECURSE CORE_FILES 
    src/pointpillar/*.cu 
    src/pointpillar/*.cpp
    src/common/tensor.cu
    src/common/tensorrt.cpp
)

####################### libpointpillar_core.so ##########################
cuda_add_library(pointpillar_core SHARED 
  	${CORE_FILES}
)

target_link_libraries(pointpillar_core
	libnvinfer.so
)
#######################################################################


####################### pointpillar program #############################
cuda_add_executable(pointpillar 
	src/main.cpp
)

target_link_libraries(pointpillar
	pointpillar_core
)
#######################################################################
