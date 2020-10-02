class Indocker::Compiler::ContextHelperFactory
  include Indocker::Import[
    "core.image_store",
  ]

  def create
    Indocker::Compiler::ContextHelper.new(
      image_store: image_store
    )
  end
end