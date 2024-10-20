#!/bin/bash

dist=(".bash_profile" ".bashrc" ".gitconfig")

echo "## create symbolic link for ..."
for d in ${dist[@]}; do
  echo $d
done
echo ""

for d in ${dist[@]}; do
  ln ./$d $HOME/$d
done