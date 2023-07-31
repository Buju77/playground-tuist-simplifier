import ProjectDescription

extension DeploymentTarget {
    public static let iOSminTargetVersion: Self = .iOS(targetVersion: RTDefaults.minimumDeploymentiOSTargetVersion, devices: .iphone)
    public static let watchOSminTargetVersion: Self = .watchOS(targetVersion: RTDefaults.minimumDeploymentWatchOSTargetVersion)

    public static let iOS14: Self = .iOS(targetVersion: "14.0", devices: .iphone)
    public static let iOS15: Self = .iOS(targetVersion: "15.0", devices: .iphone)
    public static let iOS16: Self = .iOS(targetVersion: "16.0", devices: .iphone)
    public static let iOS17: Self = .iOS(targetVersion: "17.0", devices: .iphone)
}
