import ProjectDescription

public extension Project {
  static func module(
    name: String,
    dependencies: [TargetDependency] = [],
    hasResources: Bool = false
  ) -> Self {
    let frameworkTarget = Target.target(
      name: name,
      destinations: .iOS,
      product: .staticFramework,
      bundleId: "com.gamelist.\(name)",
      deploymentTargets: .iOS("15.0"),
      infoPlist: .default,
      sources: ["\(name)/Sources/**"],
      resources: hasResources ? ["HomeModule/Resources/**"] : nil,
      dependencies: dependencies
    )
    return Project(
      name: name,
      targets: [
        frameworkTarget
      ]
    )
  }
}
