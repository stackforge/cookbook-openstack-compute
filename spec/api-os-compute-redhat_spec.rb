# encoding: UTF-8

require_relative 'spec_helper'

describe 'openstack-compute::api-os-compute' do
  describe 'redhat' do
    let(:runner) { ChefSpec::SoloRunner.new(REDHAT_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) { runner.converge(described_recipe) }

    include_context 'compute_stubs'
    include_examples 'expect_runs_nova_common_recipe'
    include_examples 'expect_creates_nova_state_dir'
    include_examples 'expect_creates_nova_lock_dir'

    it 'executes nova-manage api_db sync' do
      expect(chef_run).to run_execute('nova-manage api_db sync')
        .with(timeout: 3600,
              user: 'nova',
              group: 'nova',
              command: 'nova-manage api_db sync')
    end

    it 'upgrades openstack api packages' do
      expect(chef_run).to upgrade_package 'openstack-nova-api'
    end

    it 'starts openstack api on boot' do
      expect(chef_run).to enable_service 'openstack-nova-api'
    end

    it 'starts openstack api now' do
      expect(chef_run).to start_service 'openstack-nova-api'
    end
  end
end
