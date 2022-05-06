VERSION=	0.19.0
IMAGE_BASENAME=	step-ca

all: default

default:
	docker build \
		-f Dockerfile.fedora \
		--build-arg SMALLSTEP_CLI_VERSION=${VERSION} \
		--build-arg SMALLSTEP_CA_VERSION=${VERSION} \
		-t ${IMAGE_BASENAME}:${VERSION}-hsm .

fedora:
	docker build \
		-f Dockerfile.fedora \
		--build-arg SMALLSTEP_CLI_VERSION=${VERSION} \
		--build-arg SMALLSTEP_CA_VERSION=${VERSION} \
		-t ${IMAGE_BASENAME}:${VERSION}-hsm-fedora .

debian:
	docker build \
		-f Dockerfile.debian \
		--build-arg SMALLSTEP_CLI_VERSION=${VERSION} \
		--build-arg SMALLSTEP_CA_VERSION=${VERSION} \
		-t ${IMAGE_BASENAME}:${VERSION}-hsm-debian .

alpine:
	docker build \
		-f Dockerfile.alpine \
		--build-arg SMALLSTEP_CLI_VERSION=${VERSION} \
		--build-arg SMALLSTEP_CA_VERSION=${VERSION} \
		-t ${IMAGE_BASENAME}:${VERSION}-hsm-alpine .
