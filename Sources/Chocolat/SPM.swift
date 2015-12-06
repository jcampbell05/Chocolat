import PathKit

import PackageDescription
import POSIX
import dep
import sys

import func libc.setenv

public func parse_package(packagePath: String) throws -> PackageDescription.Package {
  // FIXME: We depend on `chswift` installation and use here
  let toolchainPath = PathKit.Path(POSIX.getenv("CHSWIFT_TOOLCHAIN") ?? "")
  libc.setenv("SPM_INSTALL_PATH", toolchainPath.parent().description, 1)
  print_if("Using libPath \(Resources.runtimeLibPath)", false)

  let package = (try Manifest(path: packagePath)).package
  print_if("Converting package \(package.name) at \(packagePath)", false)

  return package
}
