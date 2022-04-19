FROM cirrusci/flutter:stable AS builder

# RUN apt update && apt upgrade -y git unzip curl && \
#     mkdir -p /app && cd /app && \
#     git clone https://github.com/flutter/flutter.git && \
#     export PATH="$PATH:/app/flutter/bin" && \
#     flutter config --no-analytics && \
#     #flutter channel beta && \
#     flutter upgrade && \
#     flutter config --enable-web && \
#     flutter precache --web && \
#     rm -rf /usr/share/nginx/html && \
#     mkdir -p /usr/share/nginx/html && \
#     rm -rf /var/lib/apt/lists/
# 
# ENV PATH="$PATH:/app/flutter/bin"

RUN flutter config --no-analytics && \
    flutter config --enable-web

#ADD https://gitlab.com/api/v4/projects/16112282/repository/branches/main /dev/null
#RUN git clone --recurse-submodules https://gitlab.com/famedly/fluffychat.git /usr/share/nginx/html

RUN mkdir -p /var/fluffy
WORKDIR /var/fluffy

ARG version

#RUN curl --header "PRIVATE-TOKEN: $gitlab_access_token" "https://gitlab.com/api/v4/projects/16112282/packages/generic/fluffychat/$version/fluffychat-web.tar.gz" >fluffychat.tar.gz && \
    #tar -xvf fluffychat.tar.gz && \
    #rm fluffychat.tar.gz && \
RUN git clone --depth 1 https://gitlab.com/famedly/fluffychat.git . && git fetch --tags && \
    latest_release="`git describe --tags $(git rev-list --tags --max-count=10) | grep '^v' | head -1`" && \
    git checkout "$latest_release" && \
    ./scripts/prepare-web.sh && \
    flutter build web --release
    #git checkout "$version" && \
    
# RUN git checkout "$version"
#     flutter clean && \
#     flutter doctor && \
#     flutter pub get && \
#     flutter build web --web-renderer canvaskit --release --verbose


FROM nginx:alpine as release
WORKDIR /usr/share/nginx/html
COPY --from=builder /var/fluffy/build/ ./
#RUN sed -i '/<base href[^>]\+>/d' index.html
