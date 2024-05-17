#!/bin/bash
cd $(dirname $0)/
chmod 0600 ssh.key
ssh -i ssh.key ubuntu@$(cat instance-address) $*