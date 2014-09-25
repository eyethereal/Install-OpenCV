#!/bin/bash

# Dan Walkes
# 2014-01-29
# Call this script after configuring variables:
# version - the version of OpenCV to be installed
# downloadfile - the name of the OpenCV download file
# dldir - the download directory (optional, if not specified creates an OpenCV directory in the working dir)
if [[ -z "$version" ]]; then
    echo "Please define version before calling `basename $0` or use a wrapper like opencv_latest.sh"
    exit 1
fi
if [[ -z "$downloadfile" ]]; then
    echo "Please define downloadfile before calling `basename $0` or use a wrapper like opencv_latest.sh"
    exit 1
fi
if [[ -z "$dldir" ]]; then
    dldir=OpenCV
fi
if ! sudo true; then
    echo "You must have root privileges to run this script."
    exit 1
fi
set -e

echo "--- Installing OpenCV" $version

echo "--- Installing Dependencies"
source dependencies.sh

echo "--- Downloading OpenCV" $version
mkdir -p $dldir
cd $dldir
wget -O $downloadfile http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/$version/$downloadfile/download

echo "--- Installing OpenCV" $version
if echo $downloadfile | grep ".zip"; then
    unzip -q $downloadfile
else
    tar -xf $downloadfile
fi
cd opencv-$version
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D WITH_TIFF=OFF -D WITH_JASPER=OFF -D WITH_OPENEXR=OFF -D BUILD_OPENEXR=OFF -D BUILD_NEW_PYTHON_SUPPORT=OFF -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=OFF -D INSTALL_PYTHON_EXAMPLES=OFF -D BUILD_EXAMPLES=OFF -D BUILD_DOCS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_TESTS=OFF -D WITH_QT=OFF -D WITH_GTK=OFF -D WITH_OPENGL=ON -D BUILD_opencv_ml=OFF -D BUILD_opencv_legacy=OFF -D BUILD_opencv_objdetect=OFF -D BUILD_opencv_photo=OFf -D BUILD_opencv_gpu=OFF -D BUILD_opencv_ocl=OFF -D BUILD_opencv_contrib=OFF -D BUILD_opencv_java=OFF -D BUILD_opencv_stitching=OFF -D BUILD_opencv_superres=OFF -D BUILD_opencv_ts=OFF -D BUILD_opencv_videostab=OFF ..
make -j 4
sudo make install
sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig
echo "OpenCV" $version "ready to be used"
