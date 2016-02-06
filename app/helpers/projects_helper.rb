module ProjectsHelper
  def project_icon(project)
    project.name[0].capitalize! if project && project.name != ''
  end
end
