# 基础镜像：使用 CentOS 7
FROM centos:centos7.9.2009

# 更新源
RUN rm  /etc/yum.repos.d/CentOS-Base.repo

COPY CentOS-Base.repo  /etc/yum.repos.d/

RUN yum makecache && rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7-aarch64 && rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

# 安装 epel库
RUN yum install -y epel-release


# 设置工作目录
WORKDIR /root

# 安装环境依赖
# 将 install_env.sh 脚本复制到容器内
COPY install_env.sh /root/install_env.sh

# 给脚本赋予执行权限
RUN chmod +x /root/install_env.sh

# 执行安装脚本
RUN sh -x /root/install_env.sh

# 配置动态库路径
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/usr_local_lib.conf && \
    ldconfig

# 设置环境变量
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# 测试 FFmpeg 是否安装成功
RUN /usr/local/bin/ffmpeg -version