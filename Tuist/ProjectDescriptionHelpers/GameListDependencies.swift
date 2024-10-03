import ProjectDescription

public let alamofire = external("Alamofire")
public let dependencyEngine = external("DependencyEngine")
public let alamofireImage = external("AlamofireImage")
public let sdWebImage = external("SDWebImage")

private func external(_ name: String) -> TargetDependency {
    .external(name: name)
}
