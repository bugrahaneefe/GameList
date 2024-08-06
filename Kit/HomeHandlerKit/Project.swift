import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "HomeHandlerKit",
    dependencies: [
        common,
        coreUtils,
        sdWebImage,
        networkKit
    ]
)
