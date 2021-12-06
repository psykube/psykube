module Psykube::Concerns::MetadataHelper
  private def generate_metadata(*, name : String = self.name, labels = [] of StringableMap?, annotations = [] of StringableMap?, psykube_meta = true, generate_name : String? = nil, **metadata)
    labels << StringableMap{"app" => self.name}
    labels += [manifest.labels, cluster.labels].compact
    labels << LABELS if psykube_meta
    final_annotations = annotations.compact.empty? ? nil : (annotations.compact.reduce { |p, n| p.merge(n) })
    final_labels = labels.compact.reduce { |p, n| p.merge(n) }
    Pyrite::Apimachinery::Apis::Meta::V1::ObjectMeta.new(
      **metadata,
      generate_name: NameCleaner.clean(generate_name),
      name: generate_name ? nil : NameCleaner.clean(name),
      namespace: NameCleaner.clean(namespace),
      annotations: stringify_hash_values(final_annotations),
      labels: final_labels.empty? ? nil : stringify_hash_values(final_labels)
    )
  end

  private def generate_metadata(list : Array(Pyrite::Kubernetes::ObjectMetadata))
    list.map do |object|
      generate_metadata(object)
    end
  end

  private def generate_metadata(object : Pyrite::Kubernetes::ObjectMetadata)
    object.tap do |object|
      object.metadata ||= Pyrite::Apimachinery::Apis::Meta::V1::ObjectMeta.new
      metadata = object.metadata.not_nil!
      label_list = [] of StringableMap?
      label_list << StringableMap{"app" => self.name}
      label_list += [manifest.labels, cluster.labels].compact
      label_list << LABELS
      final_labels = label_list.compact.reduce { |p, n| p.merge(n) }
      metadata.labels ||= {} of String => String
      metadata.labels.try(&.merge!(stringify_hash_values(final_labels)))
      metadata.namespace = NameCleaner.clean(namespace)
      metadata.name ||= NameCleaner.clean(name)
    end
  end

  private def stringify_hash_values(map : Nil) : Nil
    nil
  end

  private def stringify_hash_values(map : StringableMap) : StringMap
    map.each_with_object(StringMap.new) do |(k, v), a|
      a[k] = v.to_s unless v.nil?
    end
  end
end
