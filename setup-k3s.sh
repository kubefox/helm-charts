#!/bin/bash

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable coredns --disable traefik --disable metrics-server --disable servicelb --disable local-storage" sh -
