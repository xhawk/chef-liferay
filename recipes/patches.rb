#
# Cookbook Name:: liferay
# Recipe:: patches
#
# Copyright 2013, Thirdwave, LLC
# Authors:
# 		Adam Krone <adam.krone@thirdwavellc.com>
#		Henry Kastler <henry.kastler@thirdwavellc.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if not "#{node['liferay']['ee']['patching_tool_zip']}" == ""
	execute "copy over patching tool" do
		command "sudo cp /vagrant/downloads/patching-tool/#{node['liferay']['ee']['patching_tool_zip']} #{node['liferay']['install_directory']}/liferay/patching-tool.zip"
	end

	execute "extract patching tool" do
		command "sudo rm -rf #{node['liferay']['install_directory']}/liferay/patching-tool"
		command "sudo unzip #{node['liferay']['install_directory']}/liferay/patching-tool.zip"
		command "sudo rm #{node['liferay']['install_directory']}/liferay/patching-tool.zip"
	end
end

bash "copy over patches" do
	code node['liferay']['ee']['move_patch_command']
	action :run
end

#create this file needed for the patch install
template "#{node['liferay']['install_directory']}/liferay/patching-tool/default.properties" do
	source "patching_tool.default.properties.erb"
	mode 00755	
	owner "liferay"
	group "liferay"	
end

execute "patching tool install" do
	command "sudo sh #{node['liferay']['install_directory']}/liferay/patching-tool/patching-tool.sh install"
end