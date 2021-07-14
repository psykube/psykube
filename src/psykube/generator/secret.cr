class Psykube::Generator::Secret < ::Psykube::Generator
  protected def result
    unless encoded_secrets.empty?
      Pyrite::Api::Core::V1::Secret.new(
        metadata: generate_metadata,
        data: encoded_secrets
      )
    end
  end

  private def encoded_secrets
    combined_secrets.each_with_object({} of String => String) do |(k, v), hash|
      hash[k] = Base64.urlsafe_encode(v)
    end
  end
end
