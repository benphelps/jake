# frozen_string_literal: true

module FindOrCreate
  def find_or_create(args, &block)
    first(args) || model.create(args.merge(association_reflection[:key] => model_object.id), &block)
  end
end

class User < Sequel::Model
  one_to_many :settings, extend: FindOrCreate
end
