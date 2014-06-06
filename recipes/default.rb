#
# Cookbook Name:: mosquitto
# Recipe:: default
#
include_recipe 'mosquitto::repo'
include_recipe 'mosquitto::server'
include_recipe 'mosquitto::client'