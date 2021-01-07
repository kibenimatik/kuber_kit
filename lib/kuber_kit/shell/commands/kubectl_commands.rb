require 'json'
require 'shellwords'

class KuberKit::Shell::Commands::KubectlCommands
  def kubectl_run(shell, command_list, kubeconfig_path: nil, namespace: nil, interactive: false)
    command_parts = []
    if kubeconfig_path
      command_parts << "KUBECONFIG=#{kubeconfig_path}"
    end

    command_parts << "kubectl"

    if namespace
      command_parts << "-n #{namespace}"
    end

    command_parts += Array(command_list)

    if interactive
      shell.interactive!(command_parts.join(" "))
    else
      shell.exec!(command_parts.join(" "))
    end
  end
  
  def apply_file(shell, file_path, kubeconfig_path: nil, namespace: nil)
    kubectl_run(shell, "apply -f #{file_path}", kubeconfig_path: kubeconfig_path, namespace: namespace)
  end

  def exec(shell, pod_name, command, args: nil, kubeconfig_path: nil, interactive: false, namespace: nil)
    command_parts = []
    command_parts << "exec"

    if args
      command_parts << args
    end

    command_parts << pod_name
    command_parts << "-- #{command}"
    kubectl_run(shell, command_parts, kubeconfig_path: kubeconfig_path, interactive: interactive, namespace: namespace)
  end

  def logs(shell, pod_name, args: nil, kubeconfig_path: nil, namespace: nil)
    command_parts = []
    command_parts << "logs"

    if args
      command_parts << args
    end

    command_parts << pod_name
    kubectl_run(shell, command_parts, kubeconfig_path: kubeconfig_path, interactive: true, namespace: namespace)
  end

  def get_resources(shell, resource_type, field_selector: nil, jsonpath: ".items[*].metadata.name", kubeconfig_path: nil, namespace: nil)
    command_parts = []
    command_parts << "get #{resource_type}"

    if field_selector
      command_parts << "--field-selector=#{field_selector}"
    end

    if jsonpath 
      command_parts << "-o jsonpath='{#{jsonpath}}'"
    end

    kubectl_run(shell, command_parts, kubeconfig_path: kubeconfig_path, namespace: namespace)
  end

  def resource_exists?(shell, resource_type, resource_name, kubeconfig_path: nil, namespace: nil)
    result = get_resources(shell, resource_type, 
      field_selector: "metadata.name=#{resource_name}", kubeconfig_path: kubeconfig_path, namespace: namespace
    )
    result && result != ""
  end

  def delete_resource(shell, resource_type, resource_name, kubeconfig_path: nil, namespace: nil)
    command = %Q{delete #{resource_type} #{resource_name}}

    kubectl_run(shell, command, kubeconfig_path: kubeconfig_path, namespace: namespace)
  end

  def patch_resource(shell, resource_type, resource_name, specs, kubeconfig_path: nil, namespace: nil)
    specs_json = JSON.dump(specs).gsub('"', '\"')

    command = %Q{patch #{resource_type} #{resource_name} -p "#{specs_json}"}

    kubectl_run(shell, command, kubeconfig_path: kubeconfig_path, namespace: namespace)
  end

  def rolling_restart(shell, resource_type, resource_name, kubeconfig_path: nil, namespace: nil)
    patch_resource(shell, resource_type, resource_name, {
      spec: {
        template: {
          metadata: {
            labels: {
              redeploy: "$(date +%s)"
            }
          }
        }
      }
    }, kubeconfig_path: kubeconfig_path, namespace: namespace)
  end
end