FROM golang:latest AS build

COPY . /app

WORKDIR /app

RUN go build -o /app/bin/server


FROM alpine:latest

COPY --from=build /app/bin/server /app/server

ENTRYPOINT "/app/server"