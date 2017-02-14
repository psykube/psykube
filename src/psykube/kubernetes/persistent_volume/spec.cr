require "../concerns/mapping"
require "../shared/selector"
require "../shared/object_reference"
require "../shared/volume_source/*"

class Psykube::Kubernetes::PersistentVolume::Spec
  Kubernetes.mapping(
    access_modes: Array(String)?,
    capacity: String?,
    claim_ref: Shared::ObjectReference?,
    persistent_volume_reclaim_policy: String?,
    host_path: Shared::VolumeSource::HostPath?,
    photon_persistent_disk: Shared::VolumeSource::PhotonPersistentDisk?,
    gce_persistent_disk: Shared::VolumeSource::GcePersistentDisk?,
    aws_elastic_block_store: Shared::VolumeSource::AwsElasticBlockStore?,
    nfs: Shared::VolumeSource::Nfs?,
    iscsi: Shared::VolumeSource::Iscsi?,
    glusterfs: Shared::VolumeSource::Glusterfs?,
    rbd: Shared::VolumeSource::Rbd?,
    flex_volume: Shared::VolumeSource::FlexVolume?,
    cinder: Shared::VolumeSource::Cinder?,
    cephfs: Shared::VolumeSource::Cephfs?,
    flocker: Shared::VolumeSource::Flocker?,
    fc: Shared::VolumeSource::Fc?,
    azure_file: Shared::VolumeSource::AzureFile?,
    vsphere_volume: Shared::VolumeSource::VsphereVolume?,
    quobyte: Shared::VolumeSource::Quobyte?,
    azure_disk: Shared::VolumeSource::AzureDisk?,
  )
end
