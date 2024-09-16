import ProjectDescription

public let homeModule = TargetDependency.project(
  target: "HomeModule",
  path: .relativeToRoot("Module/HomeModule"))
public let gameDetailModule = TargetDependency.project(
  target: "GameDetailModule",
  path: .relativeToRoot("Module/GameDetailModule"))
public let wishlistModule = TargetDependency.project(
  target: "WishlistModule",
  path: .relativeToRoot("Module/WishlistModule"))
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
public let gameDetailHandlerKit = TargetDependency.project(
  target: "GameDetailHandlerKit",
  path: .relativeToRoot("Kit/GameDetailHandlerKit"))

