import ProjectDescription

public let alamofire = external("Alamofire")
public let listingKit = external("ListingKit")
public let dependencyEngine = external("DependencyEngine")
public let alamofireImage = external("AlamofireImage")


private func external(_ name: String) -> TargetDependency {
    .external(name: name)
}
