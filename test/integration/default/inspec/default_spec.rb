
describe file('/usr/local/bin/augustus') do
  it { should be_symlink }
end

describe file('/opt/augustus-3.2.2/bin/augustus') do
  it { should be_file }
  it { should be_executable }
end

describe command('augustus') do
  its('stdout') { should match '3.2.2' }
end 
 
