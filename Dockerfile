FROM ubuntu:18.04
   
# Prerequisites
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-17-jdk wget

ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$PATH
   
# Set up new user
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer
   
# Prepare Android directories and system variables
RUN mkdir -p Android/sdk/cmdline-tools/latest/
ENV ANDROID_SDK_ROOT /home/developer/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg
   
# Set up Android SDK
RUN wget -O sdk-tools2.zip https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip
RUN unzip sdk-tools2.zip && rm sdk-tools2.zip
RUN mv cmdline-tools/* Android/sdk/cmdline-tools/latest/
RUN rm -rf cmdline-tools
RUN cd Android/sdk/cmdline-tools/latest/bin
RUN yes | ./sdkmanager --licenses
RUN cd ~/Android/sdk/cmdline-tools/latest/bin/ && ./sdkmanager "build-tools;34.0.0" "patcher;v4" "platform-tools" "platforms;android-33" "sources;android-33"
ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"

# Create workspace directory and give permissions
RUN mkdir -p /home/developer/workspace
RUN chown developer:developer /home/developer/workspace

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/developer/flutter/bin"
   
# Run basic check to download Dark SDK
RUN flutter doctor