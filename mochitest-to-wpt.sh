#!/bin/sh

set -ex

usage()
{
  echo "From a m-c mercurial checkout:"
  echo "\t$0 source dest"
  exit 1
}

if [ -z $1 ]
do
  usage $0
else
  source=$1
  shift
done

if [ -z $1 ]
do
  usage $0
else
  source=$1
  shift
done

hg_root=`hg root`
if [ -z $hg_root ]
then
  usage $0
fi

echo "Copying $source to $destination with mercurial"
hg cp $source $destination

echo "Converting to wpt"

# ...

