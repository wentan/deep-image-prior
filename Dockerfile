FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

# Install system dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential \
        curl \
        git \
    && apt-get clean

# Install python miniconda3 + requirements
ENV MINICONDA_HOME="/opt/miniconda"
ENV PATH="${MINICONDA_HOME}/bin:${PATH}"
RUN curl -o Miniconda3-latest-Linux-x86_64.sh https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && chmod +x Miniconda3-latest-Linux-x86_64.sh \
    && ./Miniconda3-latest-Linux-x86_64.sh -b -p "${MINICONDA_HOME}" \
    && rm Miniconda3-latest-Linux-x86_64.sh
COPY environment.yml environment.yml
#RUN conda config --remove channels defaults
RUN conda config --show
RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
#RUN conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/main/
RUN conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/free/
RUN conda config --add channels https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge/
RUN conda config --add channels https://mirrors.ustc.edu.cn/anaconda/cloud/msys2/
RUN conda config --add channels https://mirrors.ustc.edu.cn/anaconda/cloud/bioconda/
#RUN conda config --add channels https://mirrors.ustc.edu.cn/anaconda/cloud/menpo/

RUN conda config --show

RUN conda config --set show_channel_urls yes

RUN conda env update -n=root --file=environment.yml
RUN conda --version

RUN conda  clean --help

RUN conda clean -y -i -p -t && \
    rm environment.yml
# Clone deep image prior repository
RUN git clone https://github.com/DmitryUlyanov/deep-image-prior.git
WORKDIR /deep-image-prior

# Start container in notebook mode
CMD jupyter notebook --ip="*" --no-browser --allow-root

