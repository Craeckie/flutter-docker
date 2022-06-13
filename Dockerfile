FROM cirrusci/flutter:stable AS builder

RUN flutter config --no-analytics && \
    flutter config --enable-web && \
    flutter doctor && \
    flutter precache --web

RUN mkdir -p /var/fluffy
WORKDIR /var/fluffy

#RUN curl --header "PRIVATE-TOKEN: $gitlab_access_token" "https://gitlab.com/api/v4/projects/16112282/packages/generic/fluffychat/$version/fluffychat-web.tar.gz" >fluffychat.tar.gz && \
    #tar -xvf fluffychat.tar.gz && \
    #rm fluffychat.tar.gz && \
RUN apt update && apt install -y jq && \
    #version="`curl -s "https://gitlab.com/api/v4/projects/16112282/releases/" | jq -r '.[0].tag_name'`" && \
    url="`curl -s "https://gitlab.com/api/v4/projects/16112282/releases/" | jq -r '.[0].assets.links | .[] |select(.name == "fluffychat-web.tar.gz") | .url'`" && \
    apt remove -y jq && \
    #curl -L "https://gitlab.com/api/v4/projects/16112282/packages/generic/fluffychat/$version/fluffychat-web.tar.gz" | tar xzvf -
    curl -L "$url" | tar xzvf -
    #git clone --branch "$version" --depth 1 https://gitlab.com/famedly/fluffychat.git . && \
    #./scripts/prepare-web.sh && \
    #flutter build web --release
    #git checkout "$version" && \
    
# RUN git checkout "$version"
#     flutter clean && \
#     flutter doctor && \
#     flutter pub get && \
#     flutter build web --web-renderer canvaskit --release --verbose


FROM nginx:alpine as release
WORKDIR /usr/share/nginx/html
COPY --from=builder /var/fluffy/ ./web/
#RUN sed -i '/<base href[^>]\+>/d' index.html
