{% import "auto_setup/auto_base_map.jinja" as base_cfg %}

## get if cloud map is default

{% set dflt_cloud_providers = '/etc/salt/cloud.providers' %}
{% set dflt_cloud_profiles = '/etc/salt/cloud.profiles' %}
{% set dflt_cloud_map = '/etc/salt/cloud.map' %}

{% set build_cloud_map = pillar.get('build_cloud_map', dflt_cloud_map) %}
{% set build_py3 = pillar.get('build_py3', False) %}
{% set master_fqdn = grains.get('fqdn') %}
{% set use_existing_cloud_map = false %}


{% if base_cfg.build_cloud_hold %}

{% if build_cloud_map == dflt_cloud_map %}
{% set my_id = grains.get('id') %}
{% set use_existing_cloud_map_dict = salt.cmd.run("salt " ~ my_id ~ " file.file_exists '" ~ dflt_cloud_map ~ "' -l quiet --out=json") | load_json %}
{% if use_existing_cloud_map_dict[my_id] == True %}
{% set use_existing_cloud_map = true %}
{% endif %}
{% endif %}

{% endif %}


{% set uniqueval = base_cfg.uniqueval %}
{% if uniqueval != '' %}
{% set unique_postfix = '-' ~ uniqueval %}
{% else %}
{% set unique_postfix = '' %}
{% endif %}


{% if use_existing_cloud_map == false %}

remove_curr_providers:
  file.absent:
    - name: {{dflt_cloud_providers}}


create_dflt_providers:
  file.append:
    - name: {{dflt_cloud_providers}}
    - ignore_whitespace: False
    - text: |
        production-ec2-us-west-2-private-ips:
          location: us-west-2
          minion:
            master: {{master_fqdn}}
          grains:
            role_type: auto-pack
          id: 'use-instance-role-credentials'
          key: 'use-instance-role-credentials'
          private_key: salt://auto_setup/{{base_cfg.aws_access_priv_key_name}}
          keyname: {{base_cfg.aws_access_pub_key_name}}
          driver: ec2


remove_curr_profiles:
  file.absent:
    - name: {{dflt_cloud_profiles}}


create_dflt_profiles:
  file.append:
    - name: {{dflt_cloud_profiles}}
    - ignore_whitespace: False
    - text: |
        svc-builder-cent7{{unique_postfix}}:
          provider: production-ec2-us-west-2-private-ips
          image: ami-0ffa870f91badc247
          size: t2.medium
          private_key: /root/.ssh/{{base_cfg.aws_access_priv_key_name}}
          ssh_interface: private_ips
          network_interfaces:
            - DeviceIndex: 0
              PrivateIpAddresses:
                - Primary: True
              AssociatePublicIpAddress: True
              SubnetId: {{base_cfg.subnet_id}}
              SecurityGroupId:
                - {{base_cfg.sec_group_id}}
          del_root_vol_on_destroy: True
          del_all_vol_on_destroy: True
          tag: {'environment': 'production', 'role_type': 'auto-pack', 'created-by': 'auto-pack'}
          sync_after_install: grains
          script_args: stable 2018.3
        svc-builder-amzn2{{unique_postfix}}:
          provider: production-ec2-us-west-2-private-ips
          image: ami-0c7c8c52254e39a4a
          size: t2.medium
          private_key: /root/.ssh/{{base_cfg.aws_access_priv_key_name}}
          ssh_interface: private_ips
          network_interfaces:
            - DeviceIndex: 0
              PrivateIpAddresses:
                - Primary: True
              AssociatePublicIpAddress: True
              SubnetId: {{base_cfg.subnet_id}}
              SecurityGroupId:
                - {{base_cfg.sec_group_id}}
          del_root_vol_on_destroy: True
          del_all_vol_on_destroy: True
          tag: {'environment': 'production', 'role_type': 'auto-pack', 'created-by': 'auto-pack'}
          sync_after_install: grains
          script_args: stable 2018.3
        svc-builder-debian9{{unique_postfix}}:
          provider: production-ec2-us-west-2-private-ips
          image: ami-00beebe3b200f11f7
          size: t2.medium
          private_key: /root/.ssh/{{base_cfg.aws_access_priv_key_name}}
          ssh_interface: private_ips
          network_interfaces:
            - DeviceIndex: 0
              PrivateIpAddresses:
                - Primary: True
              AssociatePublicIpAddress: True
              SubnetId: {{base_cfg.subnet_id}}
              SecurityGroupId:
                - {{base_cfg.sec_group_id}}
          del_root_vol_on_destroy: True
          del_all_vol_on_destroy: True
          tag: {'environment': 'production', 'role_type': 'auto-pack', 'created-by': 'auto-pack'}
          sync_after_install: grains
          script_args: git fluorine
        svc-builder-u1804{{unique_postfix}}:
          provider: production-ec2-us-west-2-private-ips
          image: ami-0ba52302988a1727a
          size: t2.medium
          private_key: /root/.ssh/{{base_cfg.aws_access_priv_key_name}}
          ssh_interface: private_ips
          network_interfaces:
            - DeviceIndex: 0
              PrivateIpAddresses:
                - Primary: True
              AssociatePublicIpAddress: True
              SubnetId: {{base_cfg.subnet_id}}
              SecurityGroupId:
                - {{base_cfg.sec_group_id}}
          del_root_vol_on_destroy: True
          del_all_vol_on_destroy: True
          tag: {'environment': 'production', 'role_type': 'auto-pack', 'created-by': 'auto-pack'}
          sync_after_install: grains
          script_args: git fluorine
        svc-builder-u1604{{unique_postfix}}:
          provider: production-ec2-us-west-2-private-ips
          image: ami-09df975df682ba431
          size: t2.medium
          private_key: /root/.ssh/{{base_cfg.aws_access_priv_key_name}}
          ssh_interface: private_ips
          network_interfaces:
            - DeviceIndex: 0
              PrivateIpAddresses:
                - Primary: True
              AssociatePublicIpAddress: True
              SubnetId: {{base_cfg.subnet_id}}
              SecurityGroupId:
                - {{base_cfg.sec_group_id}}
          del_root_vol_on_destroy: True
          del_all_vol_on_destroy: True
          tag: {'environment': 'production', 'role_type': 'auto-pack', 'created-by': 'auto-pack'}
          sync_after_install: grains
          script_args: git fluorine
{%- if build_py3 == False %}
        svc-builder-amzn1{{unique_postfix}}:
          provider: production-ec2-us-west-2-private-ips
          image: ami-01550240a94a81747
          size: t2.medium
          private_key: /root/.ssh/{{base_cfg.aws_access_priv_key_name}}
          ssh_interface: private_ips
          network_interfaces:
            - DeviceIndex: 0
              PrivateIpAddresses:
                - Primary: True
              AssociatePublicIpAddress: True
              SubnetId: {{base_cfg.subnet_id}}
              SecurityGroupId:
                - {{base_cfg.sec_group_id}}
          del_root_vol_on_destroy: True
          del_all_vol_on_destroy: True
          tag: {'environment': 'production', 'role_type': 'auto-pack', 'created-by': 'auto-pack'}
          sync_after_install: grains
          script_args: stable 2016.11
        svc-builder-debian8{{unique_postfix}}:
          provider: production-ec2-us-west-2-private-ips
          image: ami-08b0808c789129e0d
          size: t2.medium
          private_key: /root/.ssh/{{base_cfg.aws_access_priv_key_name}}
          ssh_interface: private_ips
          network_interfaces:
            - DeviceIndex: 0
              PrivateIpAddresses:
                - Primary: True
              AssociatePublicIpAddress: True
              SubnetId: {{base_cfg.subnet_id}}
              SecurityGroupId:
                - {{base_cfg.sec_group_id}}
          del_root_vol_on_destroy: True
          del_all_vol_on_destroy: True
          tag: {'environment': 'production', 'role_type': 'auto-pack', 'created-by': 'auto-pack'}
          sync_after_install: grains
          script_args: git fluorine
        svc-builder-u1404{{unique_postfix}}:
          provider: production-ec2-us-west-2-private-ips
          image: ami-06fe77e2ddcefdced
          size: t2.medium
          private_key: /root/.ssh/{{base_cfg.aws_access_priv_key_name}}
          ssh_interface: private_ips
          network_interfaces:
            - DeviceIndex: 0
              PrivateIpAddresses:
                - Primary: True
              AssociatePublicIpAddress: True
              SubnetId: {{base_cfg.subnet_id}}
              SecurityGroupId:
                - {{base_cfg.sec_group_id}}
          del_root_vol_on_destroy: True
          del_all_vol_on_destroy: True
          tag: {'environment': 'production', 'role_type': 'auto-pack', 'created-by': 'auto-pack'}
          sync_after_install: grains
          script_args: git fluorine
{%- endif %}


remove_curr_map:
  file.absent:
    - name: {{dflt_cloud_map}}


create_dflt_map:
  file.append:
    - name: {{dflt_cloud_map}}
    - ignore_whitespace: False
    - text: |
        svc-builder-cent7{{unique_postfix}}:
          - svc-builder-autotest-c7m{{unique_postfix}}
        svc-builder-debian9{{unique_postfix}}:
          - svc-builder-autotest-d9m{{unique_postfix}}
        svc-builder-u1804{{unique_postfix}}:
          - svc-builder-autotest-u18m{{unique_postfix}}
        svc-builder-u1604{{unique_postfix}}:
          - svc-builder-autotest-u16m{{unique_postfix}}
{%- if build_py3 == False %}
        svc-builder-amzn1{{unique_postfix}}:
          - svc-builder-autotest-amzn1{{unique_postfix}}
        svc-builder-debian8{{unique_postfix}}:
          - svc-builder-autotest-d8m{{unique_postfix}}
        svc-builder-u1404{{unique_postfix}}:
          - svc-builder-autotest-u14m{{unique_postfix}}
{%- endif %}

{%- endif %}
## endif for if use_existing_cloud_map == false

## waiting for bootstrap to support Amazon Linux 2
##         svc-builder-amzn2{{unique_postfix}}:
##           - svc-builder-autotest-amzn2{{unique_postfix}}


## startup build minions specified in cloud map


launch_cloud_map:
  cmd.run:
    - name: "salt-cloud -l debug -y -P -m {{build_cloud_map}}"
