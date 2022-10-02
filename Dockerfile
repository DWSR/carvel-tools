FROM docker.io/library/alpine:3.16 AS fetcher

RUN apk add curl perl-utils

ADD ./fetch /bin/fetch

FROM fetcher AS kbld

ARG KBLD_VERSION
ARG KBLD_CHECKSUM

RUN /bin/fetch kbld $KBLD_VERSION $KBLD_CHECKSUM

FROM fetcher AS imgpkg

ARG IMGPKG_VERSION
ARG IMGPKG_CHECKSUM

RUN /bin/fetch imgpkg $IMGPKG_VERSION $IMGPKG_CHECKSUM

FROM fetcher AS vendir

ARG VENDIR_VERSION
ARG VENDIR_CHECKSUM

RUN /bin/fetch vendir $VENDIR_VERSION $VENDIR_CHECKSUM

FROM gcr.io/distroless/base:nonroot AS final

COPY --from=kbld /usr/local/bin/kbld /kbld
COPY --from=imgpkg /usr/local/bin/imgpkg /imgpkg
