#!/usr/bin/env bash

# Pre:
# Using Gnome, install this package first
# - network-manager-openvpn-gnome

function check() {
  if [[ $# -eq 0 ]]; then
    echo "Add 1st arg as the dirs of the ovpn files"
    exit 1
  fi
  if [[ ! -d ${1} ]]; then
    echo "Dir not exist"
    exit 1
  fi
  get_userpass ${1}
}

function get_userpass() {
  echo "Username:"
  read -s USERNAME
  echo "Password:"
  read -s PASSWORD

  iterate ${1} ${USERNAME} ${PASSWORD}
}

function iterate() {
  for file in $(ls ${1}); do
    install "${1}/${file}" ${2} ${3}
  done
}

function install() {
  filepath=$1
  filename=$(basename $filepath)
  nmcli connection import type openvpn file ${filepath}
  nmcli connection modify ${filename%.ovpn} +vpn.data username=${USERNAME}
  nmcli connection modify ${filename%.ovpn} vpn.secrets "password=${PASSWORD}"
}

check $@
