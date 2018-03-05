module Psykube::V2::Manifest::Declaration
  def generate(actor : Actor)
    Generator::List.new(self, actor).result
  end

  def get_build_contexts(cluster_name : String, basename : String, tag : String, build_context : String)
    cluster = get_cluster cluster_name
    containers.map do |container_name, container|
      BuildContext.new(
        build: !container.image,
        image: container.image || [basename, container_name].join('.'),
        tag: container.image ? nil : (container.tag || tag),
        args: container.build_args.merge(cluster.container_overrides.build_args),
        context: container.build_context || build_context,
        dockerfile: cluster.container_overrides.dockerfile
      )
    end
  end

  def get_init_build_contexts(cluster_name : String, basename : String, tag : String, build_context : String)
    cluster = get_cluster cluster_name
    init_containers.map do |container_name, container|
      BuildContext.new(
        build: !container.image,
        image: container.image || [basename, container_name].join('.'),
        tag: container.image ? nil : (container.tag || tag),
        args: container.build_args.merge(cluster.container_overrides.build_args),
        context: container.build_context || build_context,
        dockerfile: cluster.container_overrides.dockerfile
      )
    end
  end

  def get_cluster(name)
    clusters[name]? || Shared::Cluster.new
  end

  def volumes
    containers.each_with_object(VolumeMap.new) do |(container_name, container), volume_map|
      container.volumes.each do |volume_name, volume|
        volume_map["#{container_name}-#{volume_name}"] = volume
      end
    end
  end
end
