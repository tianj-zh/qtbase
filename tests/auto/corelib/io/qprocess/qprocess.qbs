import qbs

Project {
    qbsSearchPaths: ["."]
    references: [
        "fileWriterProcess",
        "test.qbs",
        "testDetached",
        "testExitCodes",
        "testForwarding",
        "testForwardingHelper",
        "testGuiProcess",
        "testProcessCrash",
        "testProcessDeadWhileReading",
        "testProcessEOF",
        "testProcessEcho",
        "testProcessEcho2",
        "testProcessEcho3",
        "testProcessEchoGui",
        "testProcessEnvironment",
        "testProcessHang",
        "testProcessNormal",
        "testProcessOutput",
        "testProcessSpacesArgs/nospace.qbs",
        "testProcessSpacesArgs/onespace.qbs",
        "testProcessSpacesArgs/twospaces.qbs",
        "testSetNamedPipeHandleState",
        "testSetWorkingDirectory",
        "testSoftExit",
        "testSpaceInName",
    ]
}
