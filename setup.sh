#!/bin/bash

script_dir=$(cd $(dirname $0);pwd)

dist=(".bash_profile" ".bashrc" ".config")

echo "## create symbolic link for ..."
for d in ${dist[@]}; do
  echo $d
  ln -sf $script_dir/$d $HOME/$d
done

exit 0
