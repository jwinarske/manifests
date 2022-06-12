# /bin/bash

set -ed

MACHINE=$1
STORAGE_TYPE=$2
BOOT_VERSION=$3
EXPECTED_MD5=$4

BOOT_BINS=${MACHINE}-bootloader-${STORAGE_TYPE}-linux-${BOOT_VERSION}
FLAT_BUILD=flat_build_${STORAGE_TYPE}
FLAT_BUILD_DIR=`pwd`/$FLAT_BUILD

SHORTMACHINE=$(echo "$MACHINE" | sed 's/-//g')

wget http://snapshots.linaro.org/96boards/${SHORTMACHINE}/linaro/rescue/${BOOT_VERSION}/${BOOT_BINS}.zip

echo "*********************************"
echo "* MD5 - Checking Boot Binaries  *"
echo "*********************************"
echo "${EXPECTED_MD5}  ${BOOT_BINS}.zip" | md5sum -c
echo "*********************************"
7z e -tzip ${BOOT_BINS}.zip -o$FLAT_BUILD_DIR/
rm -rf $FLAT_BUILD_DIR/${BOOT_BINS}
rm -rf ${BOOT_BINS}.zip

pushd $FLAT_BUILD_DIR

if [ $STORAGE_TYPE == "emmc" ]; then
    echo "*********************************"
    echo "* Staging bootloader            *"
    echo "*********************************"
    cp ../boot-${MACHINE}.img  .
    BOOT_IMG=`find -iname boot-${MACHINE}.img | sed -e "s/^\.\///g"`
    sed -i "s|filename=\"boot-erase.img\" label=\"boot\"|filename=\"${BOOT_IMG}\" label=\"boot\"|g" rawprogram0.xml

    echo "*********************************"
    echo "* eMMC - Staging rootfs         *"
    echo "*********************************"
    cp ../*.rootfs.ext4.gz .
    gunzip *.rootfs.ext4.gz
    rm *.rootfs.ext4.gz
    ROOTFS_IMG=`find -iname *.ext4 | sed -e "s/^\.\///g"`
    sed -i "s|filename=\"\" label=\"rootfs\"|filename=\"${ROOTFS_IMG}\" label=\"rootfs\"|g" rawprogram0.xml
fi

md5sum * > MD5SUMS.txt
popd

tar -czvf ${FLAT_BUILD}.tar.gz ./$FLAT_BUILD
rm -rf $FLAT_BUILD

echo "*********************************"
echo "* Flat build folder created     *"
echo "*********************************"
