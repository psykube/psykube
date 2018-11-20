module Psykube::Concerns::MetadataHelper
  private def generate_metadata(*, name : String = self.name, labels = [] of StringMap?, annotations = [] of StringMap?, psykube_meta = true, generate_name : String? = nil, **metadata)
    labels << {"app" => self.name}
    labels += [manifest.labels, cluster.labels].compact
    labels << LABELS if psykube_meta
    final_annotations = annotations.compact.empty? ? nil : (annotations.compact.reduce { |p, n| p.merge(n) })
    final_labels = labels.compact.reduce { |p, n| p.merge(n) }
    Pyrite::Apimachinery::Apis::Meta::V1::ObjectMeta.new(
      **metadata,
      generate_name: NameCleaner.clean(generate_name),
      name: generate_name ? nil : NameCleaner.clean(name),
      namespace: NameCleaner.clean(namespace),
      annotations: final_annotations,
      labels: final_labels.empty? ? nil : final_labels
    )
  end
end
