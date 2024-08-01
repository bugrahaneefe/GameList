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
