import Chocolat
import Commander
import PathKit

command(Argument<String>("Package"),
    Flag("verbose")) { (package, verbose) in
  let packagePath = Path(package).absolute().description
  let package = try parse_package(packagePath)

  if let podspec = try podspecWith(package) {
  	print(podspec)
  }
}.run()
