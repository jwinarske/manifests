 # manifest files to build Linux images with Yocto

Setup packages for build

    sudo apt-get install gawk wget git-core diffstat unzip texinfo build-essential chrpath socat cpio python python3 pip3 pexpect libsdl1.2-dev xterm make xsltproc docbook-utils fop dblatex xmlto python-git libssl-dev pv

Install Google repo

    $ mkdir -p ~/.bin
    $ PATH="${HOME}/.bin:${PATH}"
    $ curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo
    $ chmod a+rx ~/.bin/repo

Download the BSP source:

    $: PATH=${PATH}:~/bin
    $: mkdir rpi_juce_yocto
    $: cd rpi_juce_yocto
    $: repo init -u https://github.com/jwinarske/manifests.git -b master -m rpi-juce.xml
    $: repo sync -j8
    
    $: . ./sources/poky/oe-init-build-env rpi4-64
    $: bitbake-layers add-layer ../sources/meta-raspberrypi
    $: bitbake-layers add-layer ../sources/meta-clang
    $: bitbake-layers add-layer ../sources/meta-juce
    $: bitbake-layers show-layers
    $: cp ../sources/meta-juce/conf/rpi4-64-wayland.template conf/local.conf

Build Image

    $: core-image-weston
    
Image MMC card using dd

    $: dd if=sdimg_file of=/dev/myMMCdrive bs=4M
    $: sync

Boot target with updated MMC card
