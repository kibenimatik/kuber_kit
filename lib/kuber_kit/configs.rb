class KuberKit::Configs
  IMAGE_DOCKERFILE_NAME = "Dockerfile".freeze
  IMAGE_BUILD_CONTEXT_DIR = "build_context".freeze
  IMAGE_TAG = 'latest'.freeze
  IMAGE_COMPILE_DIR = "/tmp/kuber_kit/image_builds"
  DOCKER_IGNORE_LIST = [
    'Dockerfile',
    '.DS_Store',
    '**/.DS_Store',
    '**/*.log',
    'node_modules',
    '.vagrant',
    '.vscode',
    'tmp',
    'logs'
  ]
  INDOCKER_DIRNAME       = "kuber_kit".freeze
  IMAGES_DIRNAME         = "images".freeze
  INFRA_DIRNAME          = "infrastructure".freeze
  CONFIGURATIONS_DIRNAME = "configurations".freeze
  ARTIFACT_CLONE_DIR     = "/tmp/kuber_kit/artifacts"
  SERVICE_CONFIG_DIR     = "/tmp/kuber_kit/services"

  attr_accessor :image_dockerfile_name, :image_build_context_dir, :image_tag,
                :docker_ignore_list, :image_compile_dir, 
                :kuber_kit_dirname, :images_dirname, :infra_dirname, :configurations_dirname,
                :artifact_clone_dir, :service_config_dir

  def initialize
    @image_dockerfile_name   = IMAGE_DOCKERFILE_NAME
    @image_build_context_dir = IMAGE_BUILD_CONTEXT_DIR
    @image_tag               = IMAGE_TAG
    @image_compile_dir       = IMAGE_COMPILE_DIR
    @docker_ignore_list      = DOCKER_IGNORE_LIST
    @kuber_kit_dirname        = INDOCKER_DIRNAME
    @images_dirname          = IMAGES_DIRNAME
    @infra_dirname           = INFRA_DIRNAME
    @configurations_dirname  = CONFIGURATIONS_DIRNAME
    @artifact_clone_dir      = ARTIFACT_CLONE_DIR
    @service_config_dir      = SERVICE_CONFIG_DIR
  end
end