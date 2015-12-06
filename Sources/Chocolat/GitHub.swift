import Foundation

// FIXME: Should have internal visibility
public func github_data_from_remote(remote: String) -> (String, String)? {
  if remote.rangeOfString("git@github.com") != nil {
    if let meat = remote.components(":").last?.components(".").first?.components("/") {
      return (meat[0], meat[1])
    }
  } else {
    if let url = NSURL(string: remote), components = url.pathComponents {
      return (components[components.count-2], components[components.count-1])
    }
  }

  return nil
}

func github_data_from_git() -> (String, String)? {
  if let remote = runcmd(["git", "remote", "-v"])?.first, data = github_data_from_remote(remote) {
    return data
  }

  return nil
}

// FIXME: Should have internal visibility
public func git_author() -> (String, String)? {
  if let config = runcmd(["git", "config", "-l"]) {
    var author: String?
    var email: String?

    for line in config {
      let components = line.components("=")

      switch components.first! {
        case "user.name":
          author = components.last
        case "user.email":
          email = components.last
        default:
          break
      }
    }

    if let author = author, email = email {
      return (author, email)
    }
  }

  return nil
}

func git_version() -> String {
  return runcmd(["git", "tag", "--list"])?.last ?? "0.0.1"
}
