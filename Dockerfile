FROM golang:latest AS build

COPY . /app

WORKDIR /app

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /app/bin/server .

FROM alpine:latest

COPY --from=build /app/bin/server /app/server

ENTRYPOINT "/app/server"