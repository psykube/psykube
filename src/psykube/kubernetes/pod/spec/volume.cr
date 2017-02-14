require "../../concerns/mapping"
require "../../shared/volume_source/*"

class Psykube::Kubernetes::Pod::Spec::Volume
  alias Source = Shared::VolumeSource

  Kubernetes.mapping({
    name:                    String,
    host_path:               Source::HostPath?,
    empty_dir:               Source::EmptyDir?,
    gce_persistent_disk:     Source::GcePersistentDisk?,
    photon_persistent_disk:  Source::PhotonPersistentDisk?,
    aws_elastic_block_store: Source::AwsElasticBlockStore?,
    git_repo:                Source::GitRepo?,
    secret:                  Source::Secret?,
    nfs:                     Source::Nfs?,
    iscsi:                   Source::Iscsi?,
    glusterfs:               Source::Glusterfs?,
    persistent_volume_claim: Source::PersistentVolumeClaim?,
    rbd:                     Source::Rbd?,
    flex_volume:             Source::FlexVolume?,
    cinder:                  Source::Cinder?,
    cephfs:                  Source::Cephfs?,
    flocker:                 Source::Flocker?,
    downward_api:            Source::DownwardAPI?,
    fc:                      Source::Fc?,
    azure_file:              Source::AzureFile?,
    config_map:              Source::ConfigMap?,
    vsphere_volume:          Source::VsphereVolume?,
    quobyte:                 Source::Quobyte?,
    azure_disk:              Source::AzureDisk?,
  })

  def initialize(@name : String)
  end

  def initialize(@name : String, @host_path : Source::HostPath)
  end

  def initialize(@name : String, @empty_dir : Source::EmptyDir)
  end

  def initialize(@name : String, @gce_persistent_disk : Source::GcePersistentDisk)
  end

  def initialize(@name : String, @aws_elastic_block_store : Source::AwsElasticBlockStore)
  end

  def initialize(@name : String, @git_repo : Source::GitRepo)
  end

  def initialize(@name : String, @secret : Source::Secret)
  end

  def initialize(@name : String, @nfs : Source::Nfs)
  end

  def initialize(@name : String, @iscsi : Source::Iscsi)
  end

  def initialize(@name : String, @glusterfs : Source::Glusterfs)
  end

  def initialize(@name : String, @persistent_volume_claim : Source::PersistentVolumeClaim)
  end

  def initialize(@name : String, @rbd : Source::Rbd)
  end

  def initialize(@name : String, @flex_volume : Source::FlexVolume)
  end

  def initialize(@name : String, @cinder : Source::Cinder)
  end

  def initialize(@name : String, @cephfs : Source::Cephfs)
  end

  def initialize(@name : String, @flocker : Source::Flocker)
  end

  def initialize(@name : String, @downward_api : Source::DownwardAPI)
  end

  def initialize(@name : String, @fc : Source::Fc)
  end

  def initialize(@name : String, @azure_file : Source::AzureFile)
  end

  def initialize(@name : String, @config_map : Source::ConfigMap)
  end

  def initialize(@name : String, @vsphere_volume : Source::VsphereVolume)
  end

  def initialize(@name : String, @quobyte : Source::Quobyte)
  end

  def initialize(@name : String, @azure_disk : Source::AzureDisk)
  end
end
