FROM nginx

ARG version

RUN apt update && apt upgrade -y git unzip && \
    mkdir -p /app && cd /app && \
    git clone https://github.com/flutter/flutter.git && \
    export PATH="$PATH:/app/flutter/bin" && \
    flutter config --no-analytics && \
    flutter channel beta && flutter upgrade && \
    flutter config --enable-web && \
    flutter precache --web && \
    rm -rf /usr/share/nginx/html && \
    mkdir -p /usr/share/nginx/html && \
    rm -rf /var/lib/apt/lists/

ENV PATH="$PATH:/app/flutter/bin"

ADD https://gitlab.com/api/v4/projects/16112282/repository/branches/main /dev/null
RUN git clone --recurse-submodules https://gitlab.com/famedly/fluffychat.git /usr/share/nginx/html

WORKDIR /usr/share/nginx/html
    
RUN git checkout "$version"
    flutter clean && \
    flutter doctor && \
    flutter pub get && \
    flutter build web --web-renderer canvaskit --release --verbose
