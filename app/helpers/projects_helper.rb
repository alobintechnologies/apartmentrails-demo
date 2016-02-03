module ProjectsHelper
  def project_icon(project)
    project.name[0].capitalize!
  end
end
