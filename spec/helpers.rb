# frozen_string_literal: true

module HostHelpers
  HOST_DEFAULTS = { platform: 'unix',
                    roles: ['agent'],
                    snapshot: 'snap',
                    ip: 'default.ip.address',
                    private_ip: 'private.ip.address',
                    dns_name: 'default.box.tld',
                    box: 'default_box_name',
                    box_url: 'http://default.box.url',
                    image: 'default_image',
                    flavor: 'm1.large',
                    user_data: '#cloud-config\nmanage_etc_hosts: true\nfinal_message: "The host is finally up!"', }.freeze

  HOST_NAME     = 'vm%d'
  HOST_SNAPSHOT = 'snapshot%d'
  HOST_IP       = 'ip.address.for.%s'
  HOST_BOX      = 'vm2%s_of_my_box'
  HOST_BOX_URL  = 'http://address.for.my.box.%s'
  HOST_DNS_NAME = '%s.box.tld'
  HOST_TEMPLATE = '%s_has_a_template'
  HOST_PRIVATE_IP = 'private.ip.for.%s'

  def logger
    instance_double(Logger).as_null_object
  end

  def make_opts
    opts = Beaker::Options::Presets.new
    opts.presets.merge(opts.env_vars).merge({ logger: logger,
                                              host_config: 'sample.config',
                                              type: nil,
                                              pooling_api: 'http://vcloud.delivery.puppetlabs.net/',
                                              datastore: 'instance0',
                                              folder: 'Delivery/Quality Assurance/Staging/Dynamic',
                                              resourcepool: 'delivery/Quality Assurance/Staging/Dynamic',
                                              gce_project: 'beaker-compute',
                                              gce_keyfile: '/path/to/keyfile.p12',
                                              gce_password: 'notasecret',
                                              gce_email: '12345678910@developer.gserviceaccount.com',
                                              openstack_api_key: 'P1as$w0rd',
                                              openstack_username: 'user',
                                              openstack_auth_url: 'http://openstack_hypervisor.labs.net:5000/v2.0/tokens',
                                              openstack_tenant: 'testing',
                                              openstack_network: 'testing',
                                              openstack_keyname: 'nopass',
                                              floating_ip_pool: 'my_pool',
                                              security_group: %w[my_sg default], })
  end

  def generate_result(name, opts)
    result = double('result')
    stdout = opts.key?(:stdout) ? opts[:stdout] : name
    stderr = opts.key?(:stderr) ? opts[:stderr] : name
    exit_code = opts.key?(:exit_code) ? opts[:exit_code] : 0
    exit_code = [exit_code].flatten
    allow(result).to receive_messages(stdout: stdout, stderr: stderr)
    allow(result).to receive(:exit_code).and_return(*exit_code)
    result
  end

  def make_host_opts(name, opts)
    make_opts.merge({ 'HOSTS' => { name => opts } }).merge(opts)
  end

  def make_host(name, host_hash)
    host_hash = Beaker::Options::OptionsHash.new.merge(HOST_DEFAULTS.merge(host_hash))

    host = Beaker::Host.create(name, host_hash, make_opts)

    allow(host).to receive(:exec).and_return(generate_result(name, host_hash))
    allow(host).to receive(:close)
    host
  end

  def make_hosts(preset_opts = {}, amt = 3)
    hosts = []
    (1..amt).each do |num|
      name = HOST_NAME % num
      opts = { snapshot: HOST_SNAPSHOT % num,
               ip: HOST_IP % name,
               private_ip: HOST_PRIVATE_IP % name,
               dns_name: HOST_DNS_NAME % name,
               template: HOST_TEMPLATE % name,
               box: HOST_BOX % name,
               box_url: HOST_BOX_URL % name, }.merge(preset_opts)
      hosts << make_host(name, opts)
    end
    hosts
  end
end
