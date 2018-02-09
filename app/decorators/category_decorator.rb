class CategoryDecorator < Draper::Decorator
  delegate_all

  def name
    "((#{object.name}))"
  end
end
