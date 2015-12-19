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

// TODO: Should use Requests once it supports HTTPS
struct Response {
  let body: String?
}

private func get(url: String) throws -> Response {
  let request = NSURLRequest(URL: NSURL(string: url)!)
  var response: NSURLResponse?
  let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
  let body = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
  return Response(body: body)
}

public func github_license(owner owner: String, repo: String) throws -> String? {
  let response = try get("https://api.github.com/repos/\(owner)/\(repo)/license")

  if let data = response.body?.dataUsingEncoding(NSUTF8StringEncoding),
         json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
    return (json["license"] as? NSDictionary)?["key"] as? String
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
