import Foundation
import PackageDescription

public func podspecWith(package: Package) throws -> String? {
  var spec = [String:AnyObject]()
  spec["name"] = package.name
  spec["version"] = git_version()
  spec["source_files"] = "Sources"
  spec["platforms"] = [ "osx": "10.10" ]
  spec["license"] = "MIT"
  // TODO: Extract summary via GH API

  if let git_author = git_author() {
    spec["authors"] = [ git_author.0: git_author.1 ]
  }

  if let github_data = github_data_from_git() {
    let page = "https://github.com/\(github_data.0)/\(github_data.1)"
    spec["homepage"] = page
    spec["source"] = [ "git": "\(page).git", "tag": spec["version"] as! String ]
  }

  var deps = [String: Array<String>]()

  for dependency in package.dependencies {
    if let name = NSURL(string: dependency.url)?.URLByDeletingPathExtension?.lastPathComponent {
      deps[name] = [
        ">= \(dependency.versionRange.startIndex)",
        "< \(dependency.versionRange.endIndex)"
      ]
    } 
  }

  spec["dependencies"] = deps

  let json = try NSJSONSerialization.dataWithJSONObject(spec, options: .PrettyPrinted)
  return NSString(data: json, encoding: NSUTF8StringEncoding) as? String
}
