FROM golang:1.22.4 AS build

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o main .

FROM gcr.io/distroless/base-debian10
WORKDIR /
COPY --from=build /app/main .
EXPOSE 8080
USER nonroot:nonroot

ENTRYPOINT ["/main"]