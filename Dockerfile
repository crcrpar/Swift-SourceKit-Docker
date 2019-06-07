FROM swift:5.0.1-xenial

# Install git, process tools
RUN rm -rf /var/lib/apt/lists/* \
    && apt-get update -y \
    && apt-get -y --no-install-recommends install \
        git \
        procps \
        aria2 \
        libsqlite3-dev \
        libncurses-dev

WORKDIR /opt
RUN aria2c -x8 https://swift.org/builds/swift-5.0-branch/ubuntu1604/swift-5.0-DEVELOPMENT-SNAPSHOT-2019-03-24-a/swift-5.0-DEVELOPMENT-SNAPSHOT-2019-03-24-a-ubuntu16.04.tar.gz \
    && tar -xzf swift-5.0-DEVELOPMENT-SNAPSHOT-2019-03-24-a-ubuntu16.04.tar.gz \
    && mv swift-5.0-DEVELOPMENT-SNAPSHOT-2019-03-24-a-ubuntu16.04 toolchain \
    && cd /opt \
    && git clone https://github.com/apple/sourcekit-lsp \
    && cd /opt/sourcekit-lsp \
    && swift package update \
    && swift build -Xcxx -I/opt/toolchain/usr/lib/swift -Xcxx -I/opt/toolchain/usr/lib/swift/Block

# Install node.js for VSCode LeetCode
RUN apt-get -y --no-install-recommends install \
        nodejs \
        npm \
    && npm install n -g \
    && n stable \
    && apt purge- y nodejs npm \
    && exec $SHELL -l

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

ENV SOURCEKIT_TOOLCHAIN_PATH=/opt/toolchain
# Set the default shell to bash instead of sh
ENV SHELL /bin/bash
