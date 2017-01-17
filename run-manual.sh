#!/bin/bash
puppet apply --test --modulepath=/tmp/modules  --verbose --hiera_config /tmp/hiera.yaml /home/vagrant/${HOSTNAME}/manifests/default.pp
