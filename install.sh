#!/usr/bin/env bash

echo "Updating .bashrc and .zshrc with personal bashrc"
grep -qxF ". $(pwd)/bashrc.sh" ~/.bashrc || echo -e "\n. $(pwd)/bashrc.sh" >> ~/.bashrc
grep -qxF ". $(pwd)/bashrc.sh" ~/.zshrc || echo -e "\n. $(pwd)/bashrc.sh" >> ~/.zshrc