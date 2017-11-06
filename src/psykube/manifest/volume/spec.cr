require "./claim"

class Psykube::Manifest::Volume::Spec
  YAML.mapping({
    aws_elastic_block_store: {type: Pyrite::Api::Core::V1::AWSElasticBlockStoreVolumeSource, nilable: true, key: "awsElasticBlockStore"},
    azure_disk:              {type: Pyrite::Api::Core::V1::AzureDiskVolumeSource, nilable: true, key: "azureDisk"},
    azure_file:              {type: Pyrite::Api::Core::V1::AzureFileVolumeSource, nilable: true, key: "azureFile"},
    cephfs:                  {type: Pyrite::Api::Core::V1::CephFSVolumeSource, nilable: true, key: "cephfs"},
    cinder:                  {type: Pyrite::Api::Core::V1::CinderVolumeSource, nilable: true, key: "cinder"},
    config_map:              {type: Pyrite::Api::Core::V1::ConfigMapVolumeSource, nilable: true, key: "configMap"},
    downward_api:            {type: Pyrite::Api::Core::V1::DownwardAPIVolumeSource, nilable: true, key: "downwardAPI"},
    empty_dir:               {type: Pyrite::Api::Core::V1::EmptyDirVolumeSource, nilable: true, key: "emptyDir"},
    fc:                      {type: Pyrite::Api::Core::V1::FCVolumeSource, nilable: true, key: "fc"},
    flex_volume:             {type: Pyrite::Api::Core::V1::FlexVolumeSource, nilable: true, key: "flexVolume"},
    flocker:                 {type: Pyrite::Api::Core::V1::FlockerVolumeSource, nilable: true, key: "flocker"},
    gce_persistent_disk:     {type: Pyrite::Api::Core::V1::GCEPersistentDiskVolumeSource, nilable: true, key: "gcePersistentDisk"},
    git_repo:                {type: Pyrite::Api::Core::V1::GitRepoVolumeSource, nilable: true, key: "gitRepo"},
    glusterfs:               {type: Pyrite::Api::Core::V1::GlusterfsVolumeSource, nilable: true, key: "glusterfs"},
    host_path:               {type: Pyrite::Api::Core::V1::HostPathVolumeSource, nilable: true, key: "hostPath"},
    iscsi:                   {type: Pyrite::Api::Core::V1::ISCSIVolumeSource, nilable: true, key: "iscsi"},
    nfs:                     {type: Pyrite::Api::Core::V1::NFSVolumeSource, nilable: true, key: "nfs"},
    persistent_volume_claim: {type: Pyrite::Api::Core::V1::PersistentVolumeClaimVolumeSource, nilable: true, key: "persistentVolumeClaim"},
    photon_persistent_disk:  {type: Pyrite::Api::Core::V1::PhotonPersistentDiskVolumeSource, nilable: true, key: "photonPersistentDisk"},
    portworx_volume:         {type: Pyrite::Api::Core::V1::PortworxVolumeSource, nilable: true, key: "portworxVolume"},
    projected:               {type: Pyrite::Api::Core::V1::ProjectedVolumeSource, nilable: true, key: "projected"},
    quobyte:                 {type: Pyrite::Api::Core::V1::QuobyteVolumeSource, nilable: true, key: "quobyte"},
    rbd:                     {type: Pyrite::Api::Core::V1::RBDVolumeSource, nilable: true, key: "rbd"},
    scale_io:                {type: Pyrite::Api::Core::V1::ScaleIOVolumeSource, nilable: true, key: "scaleIO"},
    secret:                  {type: Pyrite::Api::Core::V1::SecretVolumeSource, nilable: true, key: "secret"},
    storageos:               {type: Pyrite::Api::Core::V1::StorageOSVolumeSource, nilable: true, key: "storageos"},
    vsphere_volume:          {type: Pyrite::Api::Core::V1::VsphereVirtualDiskVolumeSource, nilable: true, key: "vsphereVolume"},
  }, true)

  def initialize
  end

  def set_persistent_volume_claim(claim : Claim?, name : String)
    @persistent_volume_claim = Pyrite::Api::Core::V1::PersistentVolumeClaimVolumeSource.new(
      claim_name: name,
      read_only: claim.read_only
    ) if claim
  end

  def set_secret(item : String, name : String)
    set_secret([item], name)
  end

  def set_secret(items : Array(String), name : String)
    key_paths = items.map do |item|
      Pyrite::Api::Core::V1::KeyToPath.new(key: item, path: item)
    end
    set_secret(key_paths, name)
  end

  def set_secret(items : Array(Pyrite::Api::Core::V1::KeyToPath), name : String)
    set_secret Pyrite::Api::Core::V1::SecretVolumeSource.new(
      secret_name: name,
      items: items
    )
  end

  def set_secret(secret : Pyrite::Api::Core::V1::SecretVolumeSource?, name : String? = nil)
    @secret = secret
  end

  def set_config_map(item : String, name : String)
    set_config_map([item], name)
  end

  def set_config_map(items : Array(String), name : String)
    key_paths = items.map do |item|
      Pyrite::Api::Core::V1::KeyToPath.new(key: item, path: item)
    end
    set_config_map(key_paths, name)
  end

  def set_config_map(items : Array(Pyrite::Api::Core::V1::KeyToPath), name : String)
    set_config_map Pyrite::Api::Core::V1::ConfigMapVolumeSource.new(
      name: name,
      items: items
    )
  end

  def set_config_map(config_map : Pyrite::Api::Core::V1::ConfigMapVolumeSource?, name : String? = nil)
    @config_map = config_map
  end

  def to_deployment_volume(name : String)
    Pyrite::Api::Core::V1::Volume.new(
      name: name,
      aws_elastic_block_store: aws_elastic_block_store,
      azure_disk: azure_disk,
      azure_file: azure_file,
      cephfs: cephfs,
      cinder: cinder,
      config_map: config_map,
      downward_api: downward_api,
      empty_dir: empty_dir,
      fc: fc,
      flex_volume: flex_volume,
      flocker: flocker,
      gce_persistent_disk: gce_persistent_disk,
      git_repo: git_repo,
      glusterfs: glusterfs,
      host_path: host_path,
      iscsi: iscsi,
      nfs: nfs,
      persistent_volume_claim: persistent_volume_claim,
      photon_persistent_disk: photon_persistent_disk,
      portworx_volume: portworx_volume,
      projected: projected,
      quobyte: quobyte,
      rbd: rbd,
      scale_io: scale_io,
      secret: secret,
      storageos: storageos,
      vsphere_volume: vsphere_volume
    )
  end
end
