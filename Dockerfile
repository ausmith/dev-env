FROM ubuntu:16.04
ARG USERNAME
ARG USERID
ARG GROUPID

ENV HOME "/home/$USERNAME"
WORKDIR "/home/$USERNAME"

# Install pre-reqs
RUN apt-get -qq update && apt-get dist-upgrade -y && apt-get install -qy sudo apt-transport-https

# Setup my user into the appropriate groups
RUN echo "$USERNAME:x:$USERID:$GROUPID:$USERNAME:/home/$USERNAME:/bin/bash" >> /etc/passwd && \
    echo "$USERNAME:x:$GROUPID" >> /etc/group && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install main tools from main debian apt repo
RUN echo "deb http://cloudfront.debian.net/debian sid main contrib" >> /etc/apt/sources.list.d/debian_sid.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8B48AD6246925553 && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7638D0442B90D010 && \
    apt-get update -qq && \
    apt-get install -qy vim curl git wget bzip2 gcc make jq gpgv2 gnupg-agent gnupg2 \
                        jq unzip xloadimage apt-file man dnsutils bash-completion

# Install misc tools
RUN apt-get install -qy silversearcher-ag packer

# Install blackbox
RUN set -ex && \
    cd /tmp && \
    git clone https://github.com/StackExchange/blackbox.git && \
    cd blackbox && \
    cp bin/*blackbox* bin/_stack_lib.sh /usr/local/bin && \
    chmod 0755 /usr/local/bin/*blackbox* /usr/local/bin/_stack_lib.sh && \
    cd / && \
    rm -rf /tmp/blackbox

# Install terraform
RUN set -ex && \
    curl -s -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.10.2/terraform_0.10.2_linux_amd64.zip && \
    ls -lh / && \
    cd /usr/local/bin && \
    unzip /tmp/terraform.zip && \
    chmod 0755 terraform && \
    rm /tmp/terraform.zip

# Install rbenv
RUN apt-get install -qy rbenv libssl-dev libreadline-dev zlib1g-dev

# Install python
RUN apt-get install -qy python python-dev python-pip python virtualenv && \
    pip install --upgrade pip

# Install python requirements
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt && rm /tmp/requirements.txt
