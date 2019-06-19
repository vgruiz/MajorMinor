import RealmSwift
import Foundation

class Dog: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var owner: DogOwner?
//    var owner: LinkingObjects<DogOwner>()
    let owner = LinkingObjects(fromType: DogOwner.self, property: "dog")
}

class DogOwner: Object {
    //@objc dynamic var dog: Dog?
    //let dogs = List<Dog>()
    let dog = LinkingObjects(fromType: Dog.self, property: "owner")
}

let dogA = Dog()
let ownerA = DogOwner()

dogA.owner = ownerA
