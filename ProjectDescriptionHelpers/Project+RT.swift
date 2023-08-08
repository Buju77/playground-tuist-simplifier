import ProjectDescription

extension Project {
    
    /// This method creates your project
    /// - Parameters:
    ///   - name: The project name
    ///   - settings: The project's settings
    ///   - targets: The project's targets
    ///   - schemes: The project's schemes
    ///   - additionalFiles: The additional files in a project, ones that are not source files.
    ///   - resourceSynthesizers: The project's resource synthesizers
    ///   - generateSwiftlintTarget: A boolean flag to create a SwiftlintTarget, default is true
    /// - Returns: Project
    public static func makeProject(name: String,
                                   settings: Settings? = nil,
                                   targets: [Target] = [],
                                   schemes: [Scheme] = [],
                                   additionalFiles: [FileElement] = [],
                                   addDefaultAdditionalFiles: Bool = true,
                                   generateSwiftlintTarget: Bool = true) -> Project {
        var targets = targets

        /** Automatically add Swiftlint target */
        if generateSwiftlintTarget {
            let swiftlintTarget = Target.makeTarget(name: "SwiftLint",
                                                    sources: [],
                                                    scripts: [
                                                        .pre(script: "\"$SRCROOT\"/swiftlint.sh", name: "Run SwiftLint") // dummy script
                                                    ])
            targets.append(swiftlintTarget)
        }

        // create a scheme for every target per default if not passed in from the outside
        var projectSchemes = schemes
        if projectSchemes.isEmpty {
            projectSchemes = makeSchemes(targets)
        } else {
            if generateSwiftlintTarget {
                projectSchemes.append(makeSwiftLintScheme())
            }
        }

        let extraFiles = RTDefaults.makeRTAdditionalFiles(addDefaultFiles: addDefaultAdditionalFiles, otherFiles: additionalFiles)
        return Project(name: name,
                       organizationName: RTDefaults.organizationIdentifier,
                       settings: settings ?? RTDefaults.makeDefaultSettings(),
                       targets: targets,
                       schemes: projectSchemes,
                       additionalFiles: extraFiles
        )
    }
    
    fileprivate static func makeSchemes(_ targets: [Target]) -> [Scheme] {
        var projectSchemes: [Scheme] = []
        for target in targets {
            var scheme: Scheme
                scheme = Scheme.makeScheme(name: target.name)
            projectSchemes.append(scheme)
        }
        return projectSchemes
    }
    
    fileprivate static func makeSwiftLintScheme() -> Scheme {
        return Scheme.makeScheme(name: "SwiftLint")
    }
}
