#!/bin/sh -e

wget -i prerequisites.list -P $GG_SOURCE
wget -r ftp://ftp.back2roots.org/pub/back2roots/cds/fred_fish/geekgadgets_vol1_9610/ade-bin/os-include -P $GG_SOURCE
