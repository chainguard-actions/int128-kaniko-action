FROM alpine:3.18 AS builder
RUN echo "building..."

FROM alpine:3.18 AS final
COPY --from=builder /etc/alpine-release /etc/alpine-release
RUN echo "final stage"
