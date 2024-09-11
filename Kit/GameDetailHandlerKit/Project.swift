import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "GameDetailHandlerKit",
    dependencies: [
        common,
        coreUtils,
        networkKit,
        alamofireImage
    ]
)
