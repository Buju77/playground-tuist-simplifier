import ProjectDescription

public struct RTDefaults {

    public static let swiftVersion = "5.0"
    public static let minimumDeploymentiOSTargetVersion = "13.0"
    public static let minimumDeploymentWatchOSTargetVersion = "6.0"
    public static let teamID = "AAAAAAAAAA"
    public static let organizationIdentifier = "Monsters Inc."

    public static func makeRTAdditionalFiles(addDefaultFiles: Bool, otherFiles: [FileElement]) -> [FileElement] {
        guard addDefaultFiles else {
            return otherFiles
        }

        let defaultAdditionalFiles: [FileElement] = [
            "./**/.swiftlint.yml", // .swiftlint.yml file can appear in multiple directories under project root
            "Gemfile",
            "Gemfile.lock",
            "Podfile",
            "Podfile.lock",
            "Project.swift",
            "*.podspec",
            "./**/*.md", // Also catches README.md
            .folderReference(path: "Tuist")
        ]

        return defaultAdditionalFiles + otherFiles
    }

    public static func makeDefaultSettings() -> Settings {
        return .settings(
            base: SettingsDictionary().automaticCodeSigning(devTeam: teamID).swiftVersion(swiftVersion),
            debug: SettingsDictionary().automaticCodeSigning(devTeam: teamID).swiftVersion(swiftVersion),
            release: SettingsDictionary().automaticCodeSigning(devTeam: teamID).swiftVersion(swiftVersion),
            defaultSettings: .recommended)
    }

}
