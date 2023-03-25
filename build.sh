#!/bin/bash


function compile() 
{

source ~/.bashrc && source ~/.profile
export LC_ALL=C && export USE_CCACHE=1
ccache -M 100G
export ARCH=arm64
export KBUILD_BUILD_HOST=MARKxDEVS
export KBUILD_BUILD_USER="AbzRaider"
export kernel="out/arch/arm64/boot/Image.gz"
export dtb="out/arch/arm64/boot/dts/qcom/sm8150-v2.dtb"
export dtbo="out/arch/arm64/boot/dtbo.img"
git clone --depth=1 https://gitlab.com/LeCmnGend/proton-clang.git clang

if ! [ -d "out" ]; then
	echo "Kernel OUT Directory Not Found . Making Again"
mkdir out

else

	
	sleep 5
	echo "out directory already exists , Making Dirty Build !! "
	echo "If you want to clean Build , just rm -rf out"
	
fi

make O=out ARCH=arm64 RMX1931_defconfig

PATH="${PWD}/clang/bin:${PATH}:${PWD}/clang/bin:${PATH}:${PWD}/clang/bin:${PATH}" \
make -j$(nproc --all) O=out ARCH=arm64 CC=clang CLANG_TRIPLE=aarch64-linux-gnu- LD=ld.lld AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- CONFIG_NO_ERROR_ON_MISMATCH=y 2>&1 | tee error.log - Image.gz dtbo.img

}

function zupload()
{
if  [ -d "AnyKernel" ]; then	
	rm -rf AnyKernel
fi
export kernel="out/arch/arm64/boot/Image.gz"
export dtb="out/arch/arm64/boot/dts/qcom/sm8150-v2.dtb"
export dtbo="out/arch/arm64/boot/dtbo.img"
git clone --depth=1 https://github.com/AbzRaider/AnyKernel_RMX3.git -b x2PRO AnyKernel
cp $kernel $dtbo AnyKernel
cp $dtb AnyKernel/dtb
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
cd AnyKernel
zip -r9 Azrael-OSS-KERNEL-RMX1931.zip *
curl -sL https://git.io/file-transfer | sh
./transfer wet Azrael-OSS-KERNEL-RMX1931.zip
}

compile
zupload
