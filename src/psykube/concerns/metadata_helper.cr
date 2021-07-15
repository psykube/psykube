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

  private def stringify_hash_values(map : Nil) : Nil
    nil
  end

  private def stringify_hash_values(map : StringableMap) : StringMap
    map.each_with_object(StringMap.new) do |(k, v), a|
      a[k] = v.to_s unless v.nil?
    end
  end
end
