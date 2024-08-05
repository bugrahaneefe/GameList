import ProjectDescription

public let homeModule = TargetDependency.project(
  target: "HomeModule",
  path: .relativeToRoot("Module/HomeModule"))
public let networkKit = TargetDependency.project(
  target: "NetworkKit",
  path: .relativeToRoot("Kit/NetworkKit"))
public let common = TargetDependency.project(
  target: "CommonKit",
  path: .relativeToRoot("Common/CommonKit"))
public let commonViews = TargetDependency.project(
  target: "CommonViewsKit",
  path: .relativeToRoot("Common/CommonViewsKit"))
public let homeHandlerKit = TargetDependency.project(
  target: "HomeHandlerKit",
  path: .relativeToRoot("Kit/HomeHandlerKit"))
