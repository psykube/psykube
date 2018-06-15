module Psykube::Concerns::MetadataHelper
  private def generate_metadata(*, name : String = self.name, labels = [] of StringMap?, annotations = [] of StringMap?, psykube_meta = true, generate_name : String? = nil, **metadata)
    annotations << combined_annotations
    labels << {"app" => self.name}
    labels << combined_labels
    labels << LABELS if psykube_meta
    final_annotations = annotations.compact.reduce { |p, n| p.merge(n) }
    final_labels = labels.compact.reduce { |p, n| p.merge(n) }
    Pyrite::Apimachinery::Apis::Meta::V1::ObjectMeta.new(
      **metadata,
      generate_name: NameCleaner.clean(generate_name),
      name: generate_name ? nil : NameCleaner.clean(name),
      namespace: NameCleaner.clean(namespace),
      annotations: final_annotations.empty? ? nil : final_annotations,
      labels: final_labels.empty? ? nil : final_labels
    )
  end

  private def combined_labels
    sets = [manifest.labels, cluster.labels].compact
    return {} of String => String if sets.empty?
    sets.reduce { |p, n| p.merge(n) }
  end

  private def combined_annotations
    sets = [manifest.labels, cluster.labels].compact
    return {} of String => String if sets.empty?
    sets.reduce { |p, n| p.merge(n) }
  end
end
