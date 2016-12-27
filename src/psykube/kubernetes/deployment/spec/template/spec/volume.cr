require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume
  Kubernetes.mapping({
    name:                    String,
    host_path:               {type: HostPath, nilable: true, key: "hostPath"},
    empty_dir:               {type: EmptyDir, nilable: true, key: "emptyDir"},
    gce_persistent_disk:     {type: GcePersistentDisk, nilable: true, key: "gcePersistentDisk"},
    aws_elastic_block_store: {type: AwsElasticBlockStore, nilable: true, key: "awsElasticBlockStore"},
    git_repo:                {type: GitRepo, nilable: true, key: "gitRepo"},
    secret:                  {type: Secret, nilable: true},
    nfs:                     {type: Nfs, nilable: true},
    iscsi:                   {type: Iscsi, nilable: true},
    glusterfs:               {type: Glusterfs, nilable: true},
    persistent_volume_claim: {type: PersistentVolumeClaim, nilable: true, key: "persistentVolumeClaim"},
    rbd:                     {type: Rbd, nilable: true},
    flex_volume:             {type: FlexVolume, nilable: true, key: "flexVolume"},
    cinder:                  {type: Cinder, nilable: true},
    cephfs:                  {type: Cephfs, nilable: true},
    flocker:                 {type: Flocker, nilable: true},
    downward_api:            {type: DownwardAPI, nilable: true, key: "downwardAPI"},
    fc:                      {type: Fc, nilable: true},
    azure_file:              {type: AzureFile, nilable: true, key: "azureFile"},
    config_map:              {type: ConfigMap, nilable: true, key: "configMap"},
    vsphere_volume:          {type: VsphereVolume, nilable: true, key: "vsphereVolume"},
    quobyte:                 {type: Quobyte, nilable: true},
    azure_disk:              {type: AzureDisk, nilable: true, key: "azureDisk"},
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
