# Needed SHELL since I'm using zsh
SHELL := /bin/bash
.PHONY: all build_all

# Release to match data of Dockerfile and follow YYYYMMDD pattern
OTO_RELEASE=20190619

# Maximize build speed
OTO_NUMPROC := $(shell nproc --all)

## List of Targets to build: Tensorflow _ OpenCV
OTO_BUILDALL=1.13.1_3.4.6
OTO_BUILDALL+=1.13.1_4.1.0


## By default, provide the list of build targets
all:
	@echo "** Docker Image tag ending: ${OTO_RELEASE}"
	@echo ""
	@echo "** Available Docker images to be built (make targets):"
	@echo ${OTO_BUILDALL} | sed -e 's/ /\n/g' 
	@echo ""
	@echo "** To build all, use: make build_all"

## special command to build all targets
build_all:
	@make ${OTO_BUILDALL}

${OTO_BUILDALL}:
	$(eval OTO_TENSORFLOW_VERSION=$(shell echo $@ | cut -d_ -f 1))
	$(eval OTO_TENSORFLOW_TAG=${OTO_TENSORFLOW_VERSION}-py3)
	$(eval OTO_OPENCV_VERSION=$(shell echo $@ | cut -d_ -f 2))
	$(eval OTO_TAG=${OTO_TENSORFLOW_VERSION}_${OTO_OPENCV_VERSION}-${OTO_RELEASE})
	@echo ""; echo ""
	@echo "[*****] About to build openmp_tensorflow_opencv:${OTO_TAG}"
	@echo "Press Ctl+c within 5 seconds to cancel"
	@for i in 5 4 3 2 1; do echo -n "$$i "; sleep 1; done; echo ""
	docker build \
	  --build-arg OTO_TENSORFLOW_TAG=$(OTO_TENSORFLOW_TAG) \
	  --build-arg OTO_OPENCV_VERSION=${OTO_OPENCV_VERSION} \
	  --build-arg OTO_NUMPROC=$(OTO_NUMPROC) \
	  --tag="openmp_tensorflow_opencv:${OTO_TAG}" \
	  . | tee ${OTO_TAG}.log
