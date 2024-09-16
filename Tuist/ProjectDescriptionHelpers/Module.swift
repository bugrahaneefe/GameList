import ProjectDescription

public extension Project {
  static func module(
    name: String,
    dependencies: [TargetDependency] = []
  ) -> Self {
    let frameworkTarget = Target.target(
      name: name,
      destinations: .iOS,
      product: .staticFramework,
      bundleId: "com.gamelist.\(name)",
      deploymentTargets: .iOS("15.0"),
      infoPlist: .default,
      sources: ["\(name)/**/*.swift"],
      resources: [
        "\(name)/**/*.xib",
        "\(name)/**/*.storyboard",
        "\(name)/*.xcassets",
        "\(name)/**/*.strings",
        "\(name)/**/*.ttf",
        "\(name)/**/*.json",
        "\(name)/**/*.gif"
    ],
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
