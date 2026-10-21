# for multiarch build, do:
#docker buildx build \
#   --label "org.opencontainers.image.source=https://github.com/kedify/weather-prometheus-exporter" \
#   --label "org.opencontainers.image.description=Simple Prometheus exporters for weather data, forked from https://github.com/ulexxander/weather-prometheus-exporters" \
#   --label "org.opencontainers.image.licenses=MIT" \
#   . -f Dockerfile --push --platform linux/amd64,linux/arm64 -t ghcr.io/kedify/weather-prometheus-exporters
FROM --platform=$TARGETARCH golang:1.26.10@sha256:3745f1aa11822297b79113f5e84ce2bffeb039734571c39855809cfe9e5d7be6 AS builder
WORKDIR /
ENV \
  CGO_ENABLED=0 \
  GOOS=linux \
  GOARCH=amd64
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build ./main.go

FROM --platform=$TARGETARCH alpine
LABEL org.opencontainers.image.source=https://github.com/kedify/weather-prometheus-exporters
LABEL org.opencontainers.image.description="Simple Prometheus exporters for weather data, forked from https://github.com/ulexxander/weather-prometheus-exporters"
LABEL org.opencontainers.image.licenses=MIT
WORKDIR /
COPY --from=builder /main /main
EXPOSE 80
ENTRYPOINT ["/main"]

