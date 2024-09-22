import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "HomeHandlerKit",
    dependencies: [
        common,
        networkKit,
        alamofireImage
    ]
)
