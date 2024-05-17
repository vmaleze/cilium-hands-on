#!/bin/sh
ssh -i ssh.key ubuntu@$(cat instance-address) "code tunnel"