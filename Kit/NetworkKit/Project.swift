import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "NetworkKit",
    dependencies: [
        alamofire,
        common,
        alamofireImage
    ]
)
