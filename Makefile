VERSION=	0.19.0


all:
	docker build --build-arg SMALLSTEP_CA_VERSION=${VERSION} -t smallstep-ca-pkcs11:${VERSION} .
