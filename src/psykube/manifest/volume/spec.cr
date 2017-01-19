require "../../kubernetes/concerns/mapping"
require "./claim"
require "../../kubernetes/pod/spec/volume"

class Psykube::Manifest::Volume::Spec
  alias KubeVolume = Kubernetes::Pod::Spec::Volume
  Kubernetes.mapping({
    host_path:               {type: KubeVolume::HostPath, nilable: true, key: "hostPath"},
    empty_dir:               {type: KubeVolume::EmptyDir, nilable: true, key: "emptyDir"},
    gce_persistent_disk:     {type: KubeVolume::GcePersistentDisk, nilable: true, key: "gcePersistentDisk"},
    aws_elastic_block_store: {type: KubeVolume::AwsElasticBlockStore, nilable: true, key: "awsElasticBlockStore"},
    git_repo:                {type: KubeVolume::GitRepo, nilable: true, key: "gitRepo"},
    secret:                  {type: KubeVolume::Secret, nilable: true},
    nfs:                     {type: KubeVolume::Nfs, nilable: true},
    iscsi:                   {type: KubeVolume::Iscsi, nilable: true},
    glusterfs:               {type: KubeVolume::Glusterfs, nilable: true},
    persistent_volume_claim: {type: KubeVolume::PersistentVolumeClaim, nilable: true, key: "persistentVolumeClaim"},
    rbd:                     {type: KubeVolume::Rbd, nilable: true},
    flex_volume:             {type: KubeVolume::FlexVolume, nilable: true, key: "flexVolume"},
    cinder:                  {type: KubeVolume::Cinder, nilable: true},
    cephfs:                  {type: KubeVolume::Cephfs, nilable: true},
    flocker:                 {type: KubeVolume::Flocker, nilable: true},
    downward_api:            {type: KubeVolume::DownwardAPI, nilable: true, key: "downwardAPI"},
    fc:                      {type: KubeVolume::Fc, nilable: true},
    azure_file:              {type: KubeVolume::AzureFile, nilable: true, key: "azureFile"},
    config_map:              {type: KubeVolume::ConfigMap, nilable: true, key: "configMap"},
    vsphere_volume:          {type: KubeVolume::VsphereVolume, nilable: true, key: "vsphereVolume"},
    quobyte:                 {type: KubeVolume::Quobyte, nilable: true},
    azure_disk:              {type: KubeVolume::AzureDisk, nilable: true, key: "azureDisk"},
  })

  def initialize(name : String, volume_claim : Nil)
  end

  def initialize(name : String, volume_claim : Claim)
    @persistent_volume_claim = KubeVolume::PersistentVolumeClaim.new(name, volume_claim.read_only)
  end

  def to_deployment_volume(name : String)
    KubeVolume.new(name).tap do |kube_vol|
      kube_vol.host_path = self.host_path
      kube_vol.empty_dir = self.empty_dir
      kube_vol.gce_persistent_disk = self.gce_persistent_disk
      kube_vol.aws_elastic_block_store = self.aws_elastic_block_store
      kube_vol.git_repo = self.git_repo
      kube_vol.secret = self.secret
      kube_vol.nfs = self.nfs
      kube_vol.iscsi = self.iscsi
      kube_vol.glusterfs = self.glusterfs
      kube_vol.persistent_volume_claim = self.persistent_volume_claim
      kube_vol.rbd = self.rbd
      kube_vol.flex_volume = self.flex_volume
      kube_vol.cinder = self.cinder
      kube_vol.cephfs = self.cephfs
      kube_vol.flocker = self.flocker
      kube_vol.downward_api = self.downward_api
      kube_vol.fc = self.fc
      kube_vol.azure_file = self.azure_file
      kube_vol.config_map = self.config_map
      kube_vol.vsphere_volume = self.vsphere_volume
      kube_vol.quobyte = self.quobyte
      kube_vol.azure_disk = self.azure_disk
    end
  end
end
