# Copyright (c) 2023 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

require 'json'

# gcp
class GCP
  def initialize
    @project_ids = []
    @hosts = {}
  end

  def project_ids
    ids = IO.popen("gcloud projects list --format=json --filter='lifecycleState:ACTIVE'").read
    JSON.parse(ids).each { |id| @project_ids << id['projectId'] }

    @project_ids
  end

  def update_hosts(project_id)
    hs = {}
    # io_popen = IO.popen("gcloud config set project #{project_id}  >> /dev/null 2>&1")
    IO.popen("gcloud config set project #{project_id}  >> /dev/null 2>&1")
    # Process.wait(io_popen.pid)
    ins = IO.popen("gcloud compute instances list --format=json --filter='status:RUNNING'").read
    JSON.parse(ins).each do |h|
      # next if h['name'].match('gke')

      hs.merge!("#{project_id}_#{h['name']}" => h['networkInterfaces'][0]['accessConfigs'][0]['natIP'])
    end
    hs
  end

  def project_hosts
    # project_ids.each do |id|
    projects = %w[test-project]
    projects.each do |id|
      @hosts.merge!(id => update_hosts(id))
    end

    @hosts
  end
end
