# docker buildx build . -f Dockerfile --push --platform linux/amd64,linux/arm64 -t ghcr.io/kedify/weather-prometheus-exporters
FROM --platform=$TARGETARCH golang:1.17 AS builder
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
WORKDIR /weather-prometheus-exporters
COPY --from=builder /main .
EXPOSE 80
ENTRYPOINT ["/weather-prometheus-exporters/main"]


