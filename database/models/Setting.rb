# frozen_string_literal: true

class Setting < Sequel::Model
  many_to_one :user
end
