//
// Shell.swift
// Swifile
//
// Created by AppInstalleriOS on 17/02/2024.
//
//

import Foundation
import Darwin

/// Convenient function to run root helper.
/// 
/// - Parameter args: Arguments to be passed
/// - Returns: Command output and return code
func runHelper(_ args: [String]) -> (output: String, status: Int) {
    return runCommand(Bundle.main.bundlePath + "/RootHelper", args, 0)
}

// Define C functions
@_silgen_name("posix_spawnattr_set_persona_np")
func posix_spawnattr_set_persona_np(_ attr: UnsafeMutablePointer<posix_spawnattr_t?>, _ persona_id: uid_t, _ flags: UInt32) -> Int32
@_silgen_name("posix_spawnattr_set_persona_uid_np")
func posix_spawnattr_set_persona_uid_np(_ attr: UnsafeMutablePointer<posix_spawnattr_t?>, _ persona_id: uid_t) -> Int32
@_silgen_name("posix_spawnattr_set_persona_gid_np")
func posix_spawnattr_set_persona_gid_np(_ attr: UnsafeMutablePointer<posix_spawnattr_t?>, _ persona_id: uid_t) -> Int32

/// Runs a command and gets its output.
/// 
/// - Parameters:
///   - command: Full path of program to be ran
///   - args: Arguments for command
///   - uid: The user id you want the program use
///   - rootPath: The jailbreak root file system path (blank by default for rootful)
/// - Returns: Command run output and return code
func runCommand(_ command: String, _ args: [String], _ uid: uid_t, _ rootPath: String = "") -> (output: String, status: Int) {
    var pipestdout: [Int32] = [0, 0]
    var pipestderr: [Int32] = [0, 0]
    let bufsiz = Int(BUFSIZ)
    pipe(&pipestdout)
    pipe(&pipestderr)
    guard fcntl(pipestdout[0], F_SETFL, O_NONBLOCK) != -1 else {
        return ("", -1)
    }
    guard fcntl(pipestderr[0], F_SETFL, O_NONBLOCK) != -1 else {
        return ("", -2)
    }
    var pid: pid_t = 0
    let args: [String] = [String(command.split(separator: "/").last!)] + args
    let argv: [UnsafeMutablePointer<CChar>?] = args.map { $0.withCString(strdup) }
    let env = ["PATH=/usr/local/sbin:\(rootPath)/usr/local/sbin:/usr/local/bin:\(rootPath)/usr/local/bin:/usr/sbin:\(rootPath)/usr/sbin:/usr/bin:\(rootPath)/usr/bin:/sbin:\(rootPath)/sbin:/bin:\(rootPath)/bin:/usr/bin/X11:\(rootPath)/usr/bin/X11:/usr/games:\(rootPath)/usr/games"]
    let proenv: [UnsafeMutablePointer<CChar>?] = env.map { $0.withCString(strdup) }
    defer { for case let pro? in proenv { free(pro) } }
    var attr: posix_spawnattr_t?
    posix_spawnattr_init(&attr)
    posix_spawnattr_set_persona_np(&attr, 99, 1)
    posix_spawnattr_set_persona_uid_np(&attr, uid)
    posix_spawnattr_set_persona_gid_np(&attr, uid)
    var fileActions: posix_spawn_file_actions_t?
    posix_spawn_file_actions_init(&fileActions)
    posix_spawn_file_actions_addclose(&fileActions, pipestdout[0])
    posix_spawn_file_actions_addclose(&fileActions, pipestderr[0])
    posix_spawn_file_actions_adddup2(&fileActions, pipestdout[1], STDOUT_FILENO)
    posix_spawn_file_actions_adddup2(&fileActions, pipestderr[1], STDERR_FILENO)
    posix_spawn_file_actions_addclose(&fileActions, pipestdout[1])
    posix_spawn_file_actions_addclose(&fileActions, pipestderr[1])
    guard posix_spawn(&pid, rootPath + command, &fileActions, &attr, argv + [nil], proenv + [nil]) == 0 else {
        print("Failed to spawn process")
        return ("", -3)
    }
    close(pipestdout[1])
    close(pipestderr[1])
    var stdoutStr = ""
    let mutex = DispatchSemaphore(value: 0)
    let readQueue = DispatchQueue(label: "com.AppInstalleriOS.Shell.Queue", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    let stdoutSource = DispatchSource.makeReadSource(fileDescriptor: pipestdout[0], queue: readQueue)
    let stderrSource = DispatchSource.makeReadSource(fileDescriptor: pipestderr[0], queue: readQueue)
    stdoutSource.setCancelHandler {
        close(pipestdout[0])
        mutex.signal()
    }
    stderrSource.setCancelHandler {
        close(pipestderr[0])
        mutex.signal()
    }
    stdoutSource.setEventHandler {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufsiz)
        defer { buffer.deallocate() }
        let bytesRead = read(pipestdout[0], buffer, bufsiz)
        guard bytesRead > 0 else {
            if bytesRead == -1 && errno == EAGAIN {
                return
            }
            stdoutSource.cancel()
            return
        }
        let array = Array(UnsafeBufferPointer(start: buffer, count: bytesRead)) + [UInt8(0)]
        array.withUnsafeBufferPointer { ptr in
            let str = String(cString: unsafeBitCast(ptr.baseAddress, to: UnsafePointer<CChar>.self))
            stdoutStr += str
        }
    }
    stderrSource.setEventHandler {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufsiz)
        defer { buffer.deallocate() }
        let bytesRead = read(pipestderr[0], buffer, bufsiz)
        guard bytesRead > 0 else {
            if bytesRead == -1 && errno == EAGAIN {
                return
            }
            stderrSource.cancel()
            return
        }
        let array = Array(UnsafeBufferPointer(start: buffer, count: bytesRead)) + [UInt8(0)]
        array.withUnsafeBufferPointer { ptr in
            let str = String(cString: unsafeBitCast(ptr.baseAddress, to: UnsafePointer<CChar>.self))
            stdoutStr += str
        }
    }
    stdoutSource.resume()
    stderrSource.resume()
    mutex.wait()
    mutex.wait()
    var status: Int32 = 0
    waitpid(pid, &status, 0)
    return (stdoutStr, Int(status))
}