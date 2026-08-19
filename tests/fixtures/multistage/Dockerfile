FROM alpine:3.19 AS base
ARG APP_VERSION=unknown
LABEL version=$APP_VERSION

FROM base AS final
RUN echo "built version $APP_VERSION"
