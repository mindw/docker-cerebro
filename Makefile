.PHONY:	build push login clean push_oregon push_ireland

IMAGE := cerebro
TAG := 0.6.6

.PHONY:	build login push clean push_ireland push_oregon mk_repo

ACCOUNT ?= 580140558762
# ACCOUNT ?= 104059736540
REGION ?= eu-west-1
# REGION ?= us-west-2
AWS_IMAGE_IRELAND := $(ACCOUNT).dkr.ecr.eu-west-1.amazonaws.com/platform/$(IMAGE):$(TAG)
AWS_IMAGE_OREGON := $(ACCOUNT).dkr.ecr.us-west-2.amazonaws.com/platform/$(IMAGE):$(TAG)
AWS_IMAGE := $(ACCOUNT).dkr.ecr.$(REGION).amazonaws.com/platform/$(IMAGE):$(TAG)

build:
	docker build --pull -t $(IMAGE):$(TAG) .

login:
	eval $$(aws ecr get-login --no-include-email --region $(REGION))
	eval $$(aws ecr get-login --no-include-email --region eu-west-1)
	eval $$(aws ecr get-login --no-include-email --region us-west-2)

push_ireland:
	docker tag $(IMAGE):$(TAG) $(AWS_IMAGE_IRELAND)
	docker push $(AWS_IMAGE_IRELAND)

push_oregon:
	docker tag $(IMAGE):$(TAG) $(AWS_IMAGE_OREGON)
	docker push $(AWS_IMAGE_OREGON)

push:
	docker tag $(IMAGE):$(TAG) $(AWS_IMAGE)
	docker push $(AWS_IMAGE)

clean:
	-docker rmi $(IMAGE):$(TAG) $(AWS_IMAGE) $(AWS_IMAGE_OREGON) $(AWS_IMAGE_IRELAND)

mk_repo:
	aws ecr create-repository --repository-name platform/${IMAGE}
