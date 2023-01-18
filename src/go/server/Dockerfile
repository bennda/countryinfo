ARG BASE_IMAGE=golang
ARG BASE_VERSION=latest

# build project
FROM $BASE_IMAGE:$BASE_VERSION AS build
WORKDIR /src
COPY . .
RUN go build

ENTRYPOINT [ "go", "run", "." ]