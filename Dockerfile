FROM debian:latest AS build-env

# Flutter 의존성 설치
RUN apt-get update
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3
RUN apt-get clean

# Flutter SDK 설치
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Flutter 웹 설정
RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

# 프로젝트 파일 복사 및 빌드
# 나의 프로젝트에 내용들을 복사해서 docker의 container로 가져간다고 한다.
COPY . /app/
WORKDIR /app/
RUN flutter pub get
RUN flutter build web

# Nginx로 서빙
FROM nginx:1.21.1-alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html
