#!/usr/bin/env bash

set -eu

################################################################################
################################################################################
################################################################################

name_prefix="os-xx-STRS-0101-123.456.789.123"

################################################################################
################################################################################
################################################################################

streisand_www_dir="/var/www/streisand"
streisand_ov_dir="${streisand_www_dir}/openvpn"
streisand_wg_dir="${streisand_www_dir}/wireguard"

output_dir="/root/vpn-profiles"

output_global_dir="${output_dir}/all"

output_ov_dir="${output_global_dir}/ovpn"
output_ov_sl_dir="${output_ov_dir}/sslh"
output_ov_ud_dir="${output_ov_dir}/udp"

output_wg_dir="${output_global_dir}/wgrd"

output_users_dir="${output_dir}/users"

################################################################################

if [ -d "./vpn-profiles" ]
then
    mv "./vpn-profiles" "./vpn-profiles-old"
fi

mkdir -p "${output_ov_sl_dir}"
mkdir -p "${output_ov_ud_dir}"
mkdir -p "${output_wg_dir}"

################################################################################
################################################################################

### openvpn sslh

counter=1

for dir in "${streisand_ov_dir}"/*
do
    if test -d "${dir}"
    then
        counter_name="$(echo ${counter} | xargs printf %02d)"
        cp ${dir}/*-sslh.ovpn "${output_ov_sl_dir}/${name_prefix}-ovpn-sslh-${counter_name}.ovpn"
        counter=$(($counter + 1))
    fi
done

unset counter counter_name dir

################################################################################

### openvpn udp

counter=1

for dir in "${streisand_ov_dir}"/*
do
    if test -d "${dir}"
    then
        counter_name="$(echo ${counter} | xargs printf %02d)"
        cp ${dir}/*-direct-udp.ovpn "${output_ov_ud_dir}/${name_prefix}-ovpn-udp-${counter_name}.ovpn"
        counter=$(($counter + 1))
    fi
done

unset counter counter_name dir

################################################################################

### wireguard

counter=1

for filename in "${streisand_wg_dir}"/*.conf
do
    if test -f "${filename}"
    then
        counter_name="$(echo ${counter} | xargs printf %02d)"
        cp "${filename}" "${output_wg_dir}/${name_prefix}-wrgd-${counter_name}.conf"
        counter=$(($counter + 1))
    fi
done

unset counter counter_name dir

################################################################################
################################################################################

### users

user_counter=1

profile_counter=1

while [ "${user_counter}" -le "5" ]
do

    user_counter_name="$(echo ${user_counter} | xargs printf %02d)"

    user_output_dir="${output_users_dir}/${user_counter_name}"

    user_output_ov_dir="${user_output_dir}/ovpn"
    user_output_ov_sl_dir="${user_output_ov_dir}/sslh"
    user_output_ov_ud_dir="${user_output_ov_dir}/udp"

    user_output_wg_dir="${user_output_dir}/wgrd"

    ###

    mkdir -p "${user_output_ov_sl_dir}"
    mkdir -p "${user_output_ov_ud_dir}"
    mkdir -p "${user_output_wg_dir}"

    ###

    user_profile_counter=1

    while [ "${user_profile_counter}" -le "4" ]
    do

        profile_counter_name="$(echo ${profile_counter} | xargs printf %02d)"

        cp "${output_ov_sl_dir}/${name_prefix}-ovpn-sslh-${profile_counter_name}.ovpn" "${user_output_ov_sl_dir}"
        cp "${output_ov_ud_dir}/${name_prefix}-ovpn-udp-${profile_counter_name}.ovpn" "${user_output_ov_ud_dir}"
        cp "${output_wg_dir}/${name_prefix}-wrgd-${profile_counter_name}.conf" "${user_output_wg_dir}"

        profile_counter=$(($profile_counter + 1))
        user_profile_counter=$(($user_profile_counter + 1))

    done

    unset user_profile_counter

    user_counter=$(($user_counter + 1))

done

################################################################################
################################################################################
