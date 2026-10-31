FROM busybox AS base
ARG GREETING=hello
RUN echo "$GREETING" > /greeting.txt

FROM base AS final
CMD ["cat", "/greeting.txt"]
