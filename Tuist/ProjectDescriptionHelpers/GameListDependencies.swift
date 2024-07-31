import ProjectDescription

public let alamofire = external("Alamofire")

private func external(_ name: String) -> TargetDependency {
    .external(name: name)
}
