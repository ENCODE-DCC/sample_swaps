FROM ubuntu@sha256:db6697a61d5679b7ca69dbde3dad6be0d17064d5b6b0e9f7be8d456ebb337209

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:deadsnakes/ppa

RUN apt-get update && apt-get install -y \
    python3.7 \
    python3.7-dev \
    python3.7-venv \
    wget \
    git \
    libz-dev \
    libbz2-dev \
    libncurses5-dev \
    liblzma-dev \
    default-jre \
    make \
    gcc \
    autoconf

RUN git clone --branch 1.10 --single-branch https://github.com/samtools/htslib.git && \
    cd htslib && autoheader && autoconf && ./configure && make && make install

RUN git clone --branch 1.10 --single-branch https://github.com/samtools/samtools.git && \
    cd samtools && autoheader && autoconf -Wno-syntax && ./configure && make && make install 

RUN wget https://github.com/broadinstitute/picard/releases/download/2.23.3/picard.jar

RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.29.2/bedtools.static.binary && \
    mv bedtools.static.binary bedtools && chmod 755 bedtools

ENV PATH="/:${PATH}"
ENV VIRTUALENV=/opt/swapenv
RUN python3.7 -m venv $VIRTUALENV
ENV PATH="${VIRTUALENV}/bin:${PATH}"
RUN pip install --upgrade pip
RUN pip install bpython
