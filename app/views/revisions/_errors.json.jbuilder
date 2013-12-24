if errors.any?
  json.errors do
    errors.each do |key|
      json.set! key, errors[key]
    end
  end
end
