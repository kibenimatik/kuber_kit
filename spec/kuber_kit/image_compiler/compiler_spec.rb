RSpec.describe KuberKit::ImageCompiler::Compiler do
  subject{ KuberKit::ImageCompiler::Compiler.new }

  let(:image) { test_helper.image(:example) }
  let(:shell) { test_helper.shell }
  let(:builds_dir) { "/tmp/images" }

  before do
    allow(subject.image_build_dir_creator).to receive(:create)
    allow(subject.image_builder).to receive(:build)
  end

  it "creates a build dir" do
    expect(subject.image_build_dir_creator).to receive(:create).with(shell, image, "/tmp/images/example", context_helper: anything)

    subject.compile(shell, image, builds_dir)
  end

  it "builds docker image" do
    expect(subject.image_builder).to receive(:build).with(shell, image, "/tmp/images/example", context_helper: anything)

    subject.compile(shell, image, builds_dir)
  end

  it "cleans build dir after compilation" do
    expect(subject.image_builder).to receive(:build)
    expect(subject.image_build_dir_creator).to receive(:cleanup).with(shell, "/tmp/images/example")

    subject.compile(shell, image, builds_dir)
  end
end