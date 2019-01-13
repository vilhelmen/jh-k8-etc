FROM alpine:latest

RUN apk add --no-cache git curl python3 py3-cryptography jq figlet coreutils bash openssl ca-certificates

RUN pip3 install --no-cache-dir python-dxf python-gitlab docker-registry-client ipython

# WHY CAN'T WE JUST USE PACKAGE MANAGERS LIKE SANE PEOPLE

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
	&& chmod +x /usr/local/bin/kubectl

RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash && helm init --client-only

CMD ["/bin/bash"]
