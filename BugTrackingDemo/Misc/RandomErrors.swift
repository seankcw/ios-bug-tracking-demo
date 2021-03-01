import Foundation

enum CoffeeError: Error {
  case affogato
  case americano
  case cappuccino
  case latte
}

class RandomErrorGenerator {
  
  static func generate() throws {
    let random = Int.random(in: 0...3)
    switch random {
    case 0:
      throw CoffeeError.affogato
    case 1:
      throw CoffeeError.americano
    case 2:
      throw CoffeeError.cappuccino
    default:
      throw CoffeeError.latte
    }
  }
}
