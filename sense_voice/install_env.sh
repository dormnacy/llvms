#!/bin/bash

# 设置错误处理函数
handle_error() {
    echo "Error: $1"
    exit 1
}

# 更新系统
echo "Updating system..."
yum update -y || handle_error "System update failed"

# 安装开发工具和相关依赖
echo "Installing development tools and dependencies..."
yum groupinstall "Development Tools" -y || handle_error "Development tools installation failed"
yum install -y wget gcc gcc-c++ make nasm yasm pkgconfig libtool zlib-devel bzip2 bzip2-devel freetype-devel || handle_error "Dependency installation failed"

# 安装 NASM
echo "Downloading and installing NASM..."
curl -O https://www.nasm.us/pub/nasm/releasebuilds/2.16.03/nasm-2.16.03.tar.bz2 || handle_error "NASM download failed"
tar -xvf nasm-2.16.03.tar.bz2 || handle_error "NASM extraction failed"
cd nasm-2.16.03/ || handle_error "Cannot enter NASM directory"
./configure || handle_error "NASM configuration failed"
make || handle_error "NASM compilation failed"
make install || handle_error "NASM installation failed"
cd .. || handle_error "Cannot return to previous directory"

# 安装 x264 编解码器
echo "Cloning and installing x264..."
git clone --depth 1 https://code.videolan.org/videolan/x264.git || handle_error "x264 clone failed"
cd x264 || handle_error "Cannot enter x264 directory"
./configure --enable-shared || handle_error "x264 configuration failed"
make || handle_error "x264 compilation failed"
make install || handle_error "x264 installation failed"
cd .. || handle_error "Cannot return to previous directory"

# 下载并安装 FFmpeg
echo "Downloading and installing FFmpeg..."
wget https://ffmpeg.org/releases/ffmpeg-6.0.tar.gz || handle_error "FFmpeg download failed"
tar xzf ffmpeg-6.0.tar.gz || handle_error "FFmpeg extraction failed"
cd ffmpeg-6.0 || handle_error "Cannot enter FFmpeg directory"

# 配置 FFmpeg
PKG_CONFIG_PATH="/usr/local/lib/pkgconfig" ./configure \
   --prefix=/usr/local \
   --pkg-config-flags="--static" \
   --extra-cflags="-I/usr/local/include" \
   --extra-ldflags="-L/usr/local/lib" \
   --extra-libs="-lpthread -lm" \
   --bindir="/usr/local/bin" \
   --enable-gpl \
   --enable-libx264 \
   --enable-shared || handle_error "FFmpeg configuration failed"

# 编译并安装 FFmpeg
echo "Compiling and installing FFmpeg..."
make || handle_error "FFmpeg compilation failed"
make install || handle_error "FFmpeg installation failed"

# 配置动态链接库路径
echo "Configuring library path..."
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# 测试 FFmpeg 安装
echo "Testing FFmpeg installation..."
/usr/local/bin/ffmpeg -version || handle_error "FFmpeg version check failed"

echo "FFmpeg installation completed successfully."