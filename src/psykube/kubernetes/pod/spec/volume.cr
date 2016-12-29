require "../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume
  Kubernetes.mapping({
    name:                    String,
    host_path:               HostPath | Nil,
    empty_dir:               EmptyDir | Nil,
    gce_persistent_disk:     GcePersistentDisk | Nil,
    aws_elastic_block_store: AwsElasticBlockStore | Nil,
    git_repo:                GitRepo | Nil,
    secret:                  Secret | Nil,
    nfs:                     Nfs | Nil,
    iscsi:                   Iscsi | Nil,
    glusterfs:               Glusterfs | Nil,
    persistent_volume_claim: PersistentVolumeClaim | Nil,
    rbd:                     Rbd | Nil,
    flex_volume:             FlexVolume | Nil,
    cinder:                  Cinder | Nil,
    cephfs:                  Cephfs | Nil,
    flocker:                 Flocker | Nil,
    downward_api:            DownwardAPI | Nil,
    fc:                      Fc | Nil,
    azure_file:              AzureFile | Nil,
    config_map:              ConfigMap | Nil,
    vsphere_volume:          VsphereVolume | Nil,
    quobyte:                 Quobyte | Nil,
    azure_disk:              AzureDisk | Nil,
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
