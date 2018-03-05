module Psykube::Concerns::MetadataHelper
  private def generate_metadata(*, name : String = self.name, name_prefix : String? = nil, name_suffix : String? = nil, labels = [] of StringMap?, annotations = [] of StringMap?, **metadata)
    name = [name_prefix, name, name_suffix].compact.join('-')
    annotations << combined_annotations
    annotations << ANNOTATIONS
    labels << combined_labels
    labels << LABELS
    Pyrite::Apimachinery::Apis::Meta::V1::ObjectMeta.new(
      **metadata,
      name: name,
      namespace: namespace,
      annotations: annotations.compact.reduce { |p, n| p.merge(n) },
      labels: labels.compact.reduce { |p, n| p.merge(n) }
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
