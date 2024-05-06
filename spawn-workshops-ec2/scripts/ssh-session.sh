#!/bin/bash
cd $(dirname $0)/
ssh -i ssh.key $(cat instance-address)