require "../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume
  Kubernetes.mapping({
    name:                    String,
    host_path:               HostPath?,
    empty_dir:               EmptyDir?,
    gce_persistent_disk:     GcePersistentDisk?,
    aws_elastic_block_store: AwsElasticBlockStore?,
    git_repo:                GitRepo?,
    secret:                  Secret?,
    nfs:                     Nfs?,
    iscsi:                   Iscsi?,
    glusterfs:               Glusterfs?,
    persistent_volume_claim: PersistentVolumeClaim?,
    rbd:                     Rbd?,
    flex_volume:             FlexVolume?,
    cinder:                  Cinder?,
    cephfs:                  Cephfs?,
    flocker:                 Flocker?,
    downward_api:            DownwardAPI?,
    fc:                      Fc?,
    azure_file:              AzureFile?,
    config_map:              ConfigMap?,
    vsphere_volume:          VsphereVolume?,
    quobyte:                 Quobyte?,
    azure_disk:              AzureDisk?,
  })

  def initialize(@name : String)
  end

  def initialize(@name : String, @host_path : HostPath)
  end

  def initialize(@name : String, @empty_dir : EmptyDir)
  end

  def initialize(@name : String, @gce_persistent_disk : GcePersistentDisk)
  end

  def initialize(@name : String, @aws_elastic_block_store : AwsElasticBlockStore)
  end

  def initialize(@name : String, @git_repo : GitRepo)
  end

  def initialize(@name : String, @secret : Secret)
  end

  def initialize(@name : String, @nfs : Nfs)
  end

  def initialize(@name : String, @iscsi : Iscsi)
  end

  def initialize(@name : String, @glusterfs : Glusterfs)
  end

  def initialize(@name : String, @persistent_volume_claim : PersistentVolumeClaim)
  end

  def initialize(@name : String, @rbd : Rbd)
  end

  def initialize(@name : String, @flex_volume : FlexVolume)
  end

  def initialize(@name : String, @cinder : Cinder)
  end

  def initialize(@name : String, @cephfs : Cephfs)
  end

  def initialize(@name : String, @flocker : Flocker)
  end

  def initialize(@name : String, @downward_api : DownwardAPI)
  end

  def initialize(@name : String, @fc : Fc)
  end

  def initialize(@name : String, @azure_file : AzureFile)
  end

  def initialize(@name : String, @config_map : ConfigMap)
  end

  def initialize(@name : String, @vsphere_volume : VsphereVolume)
  end

  def initialize(@name : String, @quobyte : Quobyte)
  end

  def initialize(@name : String, @azure_disk : AzureDisk)
  end
end

require "./volume/*"
