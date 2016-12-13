default['augustus']['version'] = '3.2.3'
default['augustus']['install_path'] = '/usr/local'
default['augustus']['dirname'] = 'augustus-' + default['augustus']['version']
default['augustus']['config'] = '/opt/' + default['augustus']['dirname'] + '/config/'
default['augustus']['filename'] = "augustus-#{node['augustus']['version']}.tar.gz"
default['augustus']['url'] = "http://bioinf.uni-greifswald.de/augustus/binaries/#{node['augustus']['filename']}"

default['apt']['compile_time_update'] = true
