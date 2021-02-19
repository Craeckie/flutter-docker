FROM nginx

RUN apt update && apt upgrade -y git unzip && \
    mkdir -p /app && cd /app && \
    git clone https://github.com/flutter/flutter.git && \
    ./flutter/bin/flutter precache && \
    rm -rf /usr/share/nginx/html && \
    mkdir -p /usr/share/nginx/html && \
    rm -rf /var/lib/apt/lists/

ENV PATH="$PATH:/app/flutter/bin"

ADD https://gitlab.com/api/v4/projects/16112282/repository/branches/main /dev/null
RUN git clone --recurse-submodules https://gitlab.com/famedly/fluffychat.git /usr/share/nginx/html

WORKDIR /usr/share/nginx/html
    
RUN flutter config --no-analytics && \
    flutter config --enable-web && \
    flutter clean && \
    flutter pub get && \
    flutter build web --release --verbose
