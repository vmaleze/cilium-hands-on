#!/bin/bash

cd "$(dirname $0)"
code --remote ssh-remote+ubuntu@$(cat instance-address) $* /