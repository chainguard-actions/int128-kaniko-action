FROM alpine:3.19 AS builder
RUN echo "builder stage"

FROM alpine:3.19 AS final
COPY --from=builder /etc/alpine-release /etc/alpine-release
RUN echo "final stage"
