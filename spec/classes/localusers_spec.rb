require 'spec_helper'

describe 'common::localusers' do
  let(:facts){{
    :fqdn => 'foo.bar.baz',
    :operatingsystem => 'CentOS',
    :lsbdistrelease => '6.5',
    :lsbmajdistrelease => '6'
  }}

  context 'real_file' do
    $fh = Tempfile.new('localusers')
    $fh.puts("*.bar.baz,foo,100,100,/home/foo,foobar")
    $fh.close

    let(:params){{ :source => $fh.path }}

    it {
      should compile.with_all_deps
    }
  end

  it { should contain_exec('modify_local_users').with_refreshonly(true) }
  it { should contain_file('/usr/local/sbin/simp/localusers.rb').that_notifies('Exec[modify_local_users]') }

end
