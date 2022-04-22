# Smallstep CA with PKCS#11 support

ARG SMALLSTEP_CA_VERSION=0.0.0


FROM golang:alpine AS builder
ARG SMALLSTEP_CA_VERSION

RUN apk add --no-cache curl make git bash gcc musl-dev pkgconf pcsc-lite-dev

WORKDIR /src

RUN curl -L https://github.com/smallstep/certificates/releases/download/v${SMALLSTEP_CA_VERSION}/step-ca_${SMALLSTEP_CA_VERSION}.tar.gz | tar xzf -
RUN make GOFLAGS="" build && make V=1 GOFLAGS="" bin/step-ca


FROM smallstep/step-cli:${SMALLSTEP_CA_VERSION}

COPY --from=builder /src/bin/step-ca            /usr/local/bin/step-ca
COPY --from=builder /src/bin/step-awskms-init   /usr/local/bin/step-awskms-init
COPY --from=builder /src/bin/step-cloudkms-init /usr/local/bin/step-cloudkms-init
COPY --from=builder /src/bin/step-pkcs11-init   /usr/local/bin/step-pkcs11-init
COPY --from=builder /src/bin/step-yubikey-init  /usr/local/bin/step-yubikey-init

USER root
RUN apk add --no-cache libcap && setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/step-ca
RUN apk add --no-cache pcsc-lite-libs
COPY --from=builder /src/docker/entrypoint.sh /entrypoint.sh
USER step

ENV CONFIGPATH="/home/step/config/ca.json"
ENV PWDPATH="/home/step/secrets/password"

VOLUME ["/home/step"]
STOPSIGNAL SIGTERM
HEALTHCHECK CMD step ca health 2>/dev/null | grep "^ok" >/dev/null

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD exec /usr/local/bin/step-ca --password-file $PWDPATH $CONFIGPATH
