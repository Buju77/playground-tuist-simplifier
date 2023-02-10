import ProjectDescription

extension TargetDependency {
    public static func pod(name: String) -> TargetDependency {
        return TargetDependency.project(target: name, path: "Pods/\(name)")
    }
}
