require "./claim"

class Psykube::Manifest::Volume::Spec
  Macros.mapping({
    aws_elastic_block_store: {type: Pyrite::Api::Core::V1::AWSElasticBlockStoreVolumeSource, optional: true, key: "awsElasticBlockStore"},
    azure_disk:              {type: Pyrite::Api::Core::V1::AzureDiskVolumeSource, optional: true, key: "azureDisk"},
    azure_file:              {type: Pyrite::Api::Core::V1::AzureFileVolumeSource, optional: true, key: "azureFile"},
    cephfs:                  {type: Pyrite::Api::Core::V1::CephFSVolumeSource, optional: true, key: "cephfs"},
    cinder:                  {type: Pyrite::Api::Core::V1::CinderVolumeSource, optional: true, key: "cinder"},
    config_map:              {type: Pyrite::Api::Core::V1::ConfigMapVolumeSource, optional: true, key: "configMap"},
    downward_api:            {type: Pyrite::Api::Core::V1::DownwardAPIVolumeSource, optional: true, key: "downwardAPI"},
    empty_dir:               {type: Pyrite::Api::Core::V1::EmptyDirVolumeSource, optional: true, key: "emptyDir"},
    fc:                      {type: Pyrite::Api::Core::V1::FCVolumeSource, optional: true, key: "fc"},
    flex_volume:             {type: Pyrite::Api::Core::V1::FlexVolumeSource, optional: true, key: "flexVolume"},
    flocker:                 {type: Pyrite::Api::Core::V1::FlockerVolumeSource, optional: true, key: "flocker"},
    gce_persistent_disk:     {type: Pyrite::Api::Core::V1::GCEPersistentDiskVolumeSource, optional: true, key: "gcePersistentDisk"},
    git_repo:                {type: Pyrite::Api::Core::V1::GitRepoVolumeSource, optional: true, key: "gitRepo"},
    glusterfs:               {type: Pyrite::Api::Core::V1::GlusterfsVolumeSource, optional: true, key: "glusterfs"},
    host_path:               {type: Pyrite::Api::Core::V1::HostPathVolumeSource, optional: true, key: "hostPath"},
    iscsi:                   {type: Pyrite::Api::Core::V1::ISCSIVolumeSource, optional: true, key: "iscsi"},
    nfs:                     {type: Pyrite::Api::Core::V1::NFSVolumeSource, optional: true, key: "nfs"},
    persistent_volume_claim: {type: Pyrite::Api::Core::V1::PersistentVolumeClaimVolumeSource, optional: true, key: "persistentVolumeClaim"},
    photon_persistent_disk:  {type: Pyrite::Api::Core::V1::PhotonPersistentDiskVolumeSource, optional: true, key: "photonPersistentDisk"},
    portworx_volume:         {type: Pyrite::Api::Core::V1::PortworxVolumeSource, optional: true, key: "portworxVolume"},
    projected:               {type: Pyrite::Api::Core::V1::ProjectedVolumeSource, optional: true, key: "projected"},
    quobyte:                 {type: Pyrite::Api::Core::V1::QuobyteVolumeSource, optional: true, key: "quobyte"},
    rbd:                     {type: Pyrite::Api::Core::V1::RBDVolumeSource, optional: true, key: "rbd"},
    scale_io:                {type: Pyrite::Api::Core::V1::ScaleIOVolumeSource, optional: true, key: "scaleIO"},
    secret:                  {type: Pyrite::Api::Core::V1::SecretVolumeSource, optional: true, key: "secret"},
    storageos:               {type: Pyrite::Api::Core::V1::StorageOSVolumeSource, optional: true, key: "storageos"},
    vsphere_volume:          {type: Pyrite::Api::Core::V1::VsphereVirtualDiskVolumeSource, optional: true, key: "vsphereVolume"},
  })
end
