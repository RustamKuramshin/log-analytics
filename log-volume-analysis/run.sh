#!/usr/bin/env bash

docker run --rm -it -v $(pwd):/ansible/playbooks ansible-playbook -i ./production.yml analysis.yml