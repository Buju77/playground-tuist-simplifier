import ProjectDescription

/// Carve out as much common stuff as possible, so that little details need to be passed from Project.swift
/// Use Runtastic defaults wherever possible like certain settings, deployment versions etc
extension Target {

    // MARK: - Main Factory Method

    /// This helper method creates a target in the project
    /// - Parameters:
    ///   - name: The name of the target.
    ///   - platform: The platform the target product is built for.. iOS, macOS etc.
    ///   - product: The type of build product this target will output.
    ///   - bundleId: The product bundle identifier.
    ///   - deploymentTarget: The minimum deployment target your product will support.
    ///   - infoPlist: The Info.plist representation.
    ///   - sources: The source files of the target.
    ///   - excluding: Path to the files that need to be excluded from project-generation
    ///   - resources: The resource files of target.
    ///   - publicHeaderPaths: The public header paths
    ///   - privateHeaderPaths: The private header paths
    ///   - entitlements: The entitlements file path for the target.
    ///   - scripts: The scripts that a target should execute.
    ///   - dependencies: The target's dependencies.
    ///   - settings: The target's settings.
    ///   - containsObjCFiles: If flag is true, it will automatically set the public header paths to the same file pattern as `sources` per default. Public headers can still be overriden by passing it in from the outside.
    public static func makeTarget(name: String,
                                  platform: ProjectDescription.Platform = .iOS,
                                  product: ProjectDescription.Product = .framework, // or [.app | .unitTests | .uiTests]
                                  bundleId: String? = nil,
                                  deploymentTarget: ProjectDescription.DeploymentTarget = .iOSminTargetVersion,
                                  infoPlist: ProjectDescription.InfoPlist? = .default,
                                  sources: ProjectDescription.SourceFilesList? = nil,
                                  excluding: [String]? = nil,
                                  resources: ProjectDescription.ResourceFileElements? = nil,
                                  publicHeaderPaths: [String]? = nil,
                                  privateHeaderPaths: [String]? = nil,
                                  entitlements: ProjectDescription.Path? = nil,
                                  scripts: [ProjectDescription.TargetScript] = [],
                                  dependencies: [ProjectDescription.TargetDependency] = [],
                                  settings: ProjectDescription.Settings? = nil,
                                  containsObjCFiles: Bool = false) -> ProjectDescription.Target {

        // Convert from simply Swift Foundation types to Tuist types
        let sourceFilesList = makeSourceFilesListAndAddExcludingPaths(name, sources, excluding)

        // use the same pattern as `sources` per default for all ObjC files as public headers if public headers wasn't passed from the outside
        let headers = useSameSourcesPatternForPublicHeadersPerDefault(containsObjCFiles, sourceFilesList, excluding, publicHeaderPaths, privateHeaderPaths)

        let defaultSettings = settings ?? RTDefaults.makeDefaultSettings()

        return self.init(name: name,
                         platform: platform,
                         product: product,
                         bundleId: bundleId ?? "inc.monsters.ios.\(name)",
                         deploymentTarget: deploymentTarget,
                         infoPlist: infoPlist,
                         sources: sourceFilesList,
                         resources: resources,
                         headers: headers,
                         entitlements: entitlements,
                         scripts: scripts,
                         dependencies: dependencies,
                         settings: defaultSettings)
    }

    // MARK: - Private Helpers

    private static func makeSourceFilesListAndAddExcludingPaths(_ targetName: String,
                                                                _ sources: SourceFilesList?,
                                                                _ excluding: [String]?) -> SourceFilesList {

        let sourcesList = sources ?? ["\(targetName)/Classes/**"]
        guard let excluding else {
            return sourcesList
        }

        // add excluding source file pattern when it was specified
        let excludingSources = excluding.map { Path(stringLiteral: $0) }
        let sourceFileGlobsArray = sourcesList.globs.map { sourceGlob in
            if sourceGlob.excluding.isEmpty {
                return SourceFileGlob.glob(sourceGlob.glob, excluding: excludingSources)
            }
            return sourceGlob
        }

        return ProjectDescription.SourceFilesList(globs: sourceFileGlobsArray)
    }

    /// This method basically converts Swift foundation types into Tuist types.
    ///
    /// Additionally will use the same file patterns as `sources` for the public headers by default if not set.
    private static func useSameSourcesPatternForPublicHeadersPerDefault(_ containsObjCFiles: Bool,
                                                                        _ sources: SourceFilesList?,
                                                                        _ excluding: [String]?,
                                                                        _ publicHeaderPaths: [String]?,
                                                                        _ privateHeaderPaths: [String]?) -> ProjectDescription.Headers? {

        // early exit if we don't have any ObjC files and headers or neither public or private headers are set
        let hasObjCFilesAndHeaders = containsObjCFiles || (publicHeaderPaths != nil || privateHeaderPaths != nil)
        guard hasObjCFilesAndHeaders else {
            return nil
        }

        var publicList: FileList?
        var privateList: FileList?

        let excludingSources: [Path] = excluding?.map { Path(stringLiteral: $0) } ?? []

        // convert Swift foundation types to Tuist types
        if let publicHeaderPaths {
            publicList = FileList.list(publicHeaderPaths.map { FileListGlob.glob(Path.init($0), excluding: excludingSources) })
        } else if let sources {
            // also use `sources` file pattern for public headers per default if public headers are not set
            publicList = FileList.list(sources.globs.map { FileListGlob.glob($0.glob, excluding: excludingSources) })
        }
        if let privateHeaderPaths {
            privateList = FileList.list(privateHeaderPaths.map { FileListGlob(stringLiteral: $0) })
        }

        return Headers.headers(public: publicList, private: privateList)
    }
}
