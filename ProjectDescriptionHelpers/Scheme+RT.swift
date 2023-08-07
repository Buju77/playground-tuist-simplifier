import ProjectDescription

/// Carve out as much common stuff as possible, so that little details need to be passed from Project,swift
/// Use Runtastic defaults wherever possible like certain settings, deployment versions etc

extension Scheme {
    
    // MARK: - Convenience Helpers

    /// This will create a test scheme
    /// - Parameters:
    ///   - name: The name of the test scheme.
    ///   - shared: Pass true if you want the scheme to be shared.
    ///   - hidden: Pass true if you want the scheme to be hidden.
    ///   - buildAction: Pass the build action of the scheme.
    ///   - testAction: Pass the test action of the scheme.
    ///   - archiveAction: Pass the archive action of the scheme.
    ///   - profileAction: Pass the profile action of the scheme.
    ///   - analyzeAction: Pass the analyze action of the scheme.
    public static func makeScheme(name: String,
                                  shared: Bool = false,
                                  hidden: Bool = false,
                                  buildAction: BuildAction? = nil,
                                  testAction: TestAction? = nil,
                                  runAction: RunAction? = nil,
                                  archiveAction: ArchiveAction? = nil,
                                  profileAction: ProfileAction? = nil,
                                  analyzeAction: AnalyzeAction? = nil,
                                  runArguments: Arguments? = nil) -> Scheme {
        
        let testsTargetReference = TargetReference(stringLiteral: name)
        let testableTarget = TestableTarget(target: testsTargetReference)
        
        return self.init(name: name,
                         shared: shared,
                         hidden: hidden,
                         buildAction: buildAction ?? .buildAction(targets: [testsTargetReference]),
                         testAction: testAction ?? .targets([testableTarget], options: .options(coverage: true)),
                         runAction: runAction ?? .runAction(executable: testsTargetReference, arguments: runArguments),
                         archiveAction: archiveAction,
                         profileAction: profileAction,
                         analyzeAction: analyzeAction)
    }
}

