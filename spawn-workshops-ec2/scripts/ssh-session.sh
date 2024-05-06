#!/bin/bash
cd $(dirname $0)/
ssh -i ssh.key ubuntu@$(cat instance-address)