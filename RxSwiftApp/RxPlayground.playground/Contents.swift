import UIKit
import RxSwift
import RxCocoa
extension Event {
    
    func display() {
        guard let val = element else {
            print("(DEBUG) No Value!")
            return
        }
        print("(DEBUG) Value : ", val)
    }
}

extension Observable {
    
    func display(with: DisposeBag) {
        subscribe { $0.display() }.disposed(by: with)
    }
}

extension String {
    subscript(idx: Int) -> String {
        String(self[index(startIndex, offsetBy: idx)])
    }
}

let disposeBag = DisposeBag()
//let obs = Observable.of("A","B","C").subscribe { print($0) }.disposed(by: disposeBag)
//let obs = Observable.of("A","B","C").subscribe { $0.display() }.disposed(by: disposeBag)
//let obsTwo = Observable.from(["A","B","C"]).subscribe { $0.display() }.disposed(by: disposeBag)
//let obsThree = Observable.of(["A","B","C"]).subscribe { $0.display() }.disposed(by: disposeBag)
////let obsTwo = Observable<String>.create { val in
////    val.onNext("A")
////    val.onCompleted()
////    val.onNext("?")
////    return Disposables.create()
////}.subscribe {
////    print("(DEBUG) val : ",$0)
////} onError: {
////    print("(ERROR) err : ", $0)
////} onCompleted: { print("(DEBUG) Completed!") } onDisposed: {  print("(DEBUG) Disposed!") }
////    .disposed(by: disposeBag)
//
////let obsTwo = Observable<String>.create { val in
////    val.onNext("A")
////    val.onCompleted()
////    val.onNext("?")
////    return Disposables.create()
////}.subscribe {
////    switch $0 {
////        case .next(let val):
////            print("(DEBUG) val : ", val)
////        case .completed:
////            print("(DEBUG) Completed")
////        case .error(let err):
////            print("(DEBUG) err : ", err)
////    }
////}
////.disposed(by: disposeBag)
////
////MARK: - Published Subject
////
//let subject = PublishSubject<String>()
//
//subject.onNext("Issue 1")
//
//subject.subscribe { print($0) } onError: { print($0) } onCompleted: {
//    print("(DEBUG) Completed!")
//} onDisposed: {
//    print("(DEBUG) Disposed")
//}
//
//subject.onNext("Issue 2")
//subject.onNext("Issue 3")
//
//subject.dispose()
//
//subject.onNext("Issue 4")
////
////MARK: - BehaviorSubject
////
//let bSubject = BehaviorSubject(value: "Init")
//bSubject.subscribe { $0.display() }.disposed(by: disposeBag)
//bSubject.onNext("A")
//
//bSubject.onNext("B")
//
//bSubject.onNext("C")
//bSubject.onNext("D")
//
////MARK: - ReplayBehaviorSubject
////
//let replySubject = ReplaySubject<String>.create(bufferSize: 2)
//
//for i in 0...3 {
//    replySubject.onNext("Subj \(i)")
//}
//
//replySubject.subscribe {
//    print($0.element ?? "")
//}.disposed(by: disposeBag)
//
//for i in 4...6 {
//    replySubject.onNext("Subj \(i)")
//}
//
////MARK: - BehaviorRelay
////print("(DEBUG) BehaviorRelay ============")
//let relay = BehaviorRelay(value: "Hello")
//relay.accept("Hello World")
//relay.accept("Hello World!")
//relay.asObservable().subscribe { $0.display() }
////
////relay.accept("Hello World!!")
////
////let arrRelay = BehaviorRelay(value: [String]())
////
////var valueArr = arrRelay.value
////valueArr.append("A")
////valueArr.append("B")
////arrRelay.accept(valueArr)
////
////arrRelay.asObservable().subscribe { $0.display() }.dispose()
//
//
////MARK: - IgnoreElements
//
//let obj = PublishSubject<Int>()
//
////obj.ignoreElements().subscribe { _ in
////    print("(DEBUG) hello!")
////}.disposed(by: disposeBag)
//
////obj.onCompleted()
//
////MARK: - ElementAt
//
////obj.element (at: 2).subscribe { _ in
////    print("CAlling on second Update!")
////}.disposed(by: disposeBag)
////obj.onNext(1)
////obj.onNext(2)
//
//
////MARK: - Filter
//
//let obsObj = Observable.of(1,2,3,4,5,6,7,8,9,10)
//
////obsObj.filter { $0 % 2 == 0}
////    .subscribe {
////        print("(DEBUG) filteredValue : ", $0.element ?? 0)
////    }
////    .disposed(by: disposeBag)
//
////MARK: - Skip
//
////obj.skip(2).subscribe { print($0.element) }.disposed(by: disposeBag)
////for x in 0..<10{
////    obj.onNext(x)
////}
//
////MARK: - SkipWhile
//
////obj.skip(while: { $0 == 3 }).subscribe { print($0.element) }.disposed(by: disposeBag)
////for x in 3..<10{
////    obj.onNext(x)
////}
//
//
////MARK: - SkipUntil
//let triggerObj = PublishSubject<Bool>()
////
////obj.skip(until: triggerObj).subscribe { print($0.element) }.disposed(by: disposeBag)
////for x in 1..<5{
////    obj.onNext(x)
////}
////
////triggerObj.onNext(true)
////for x in 5..<10{
////    obj.onNext(x)
////}
//
////MARK: - Take
//
////obsObj.take(3).subscribe{ print($0.element) }
//
////MARK: - TakeWhile
//
////obsObj.filter { $0 % 2 == 0 || $0 % 3 == 0 }.take(while: { $0 % 2 == 0 }).subscribe{ print($0.element) }.disposed(by: disposeBag)
//
//
////MARK: - TakeUntil
//
////obj.take(until: triggerObj).subscribe{ $0.display() }.disposed(by: disposeBag)
////
////obj.onNext(1)
////obj.onNext(2)
////triggerObj.onNext(true)
////obj.onNext(3)
////obj.onNext(4)
//
//
////MARK: - ToArray
//
////obsObj.toArray()
////    .subscribe({ print($0) }).disposed(by: disposeBag)
//
////MARK: - Map
//
////obsObj.map { $0 * 2 }.subscribe { print($0.element) }.disposed(by: disposeBag)
//
////MARK: - FlatMap
//
//struct Student {
//    var score: BehaviorRelay<Int>
//}
//
//let john = Student(score: .init(value: 20))
//let terry = Student(score: .init(value: 15))
//
//let student = PublishSubject<Student>()
////
////student.asObservable().flatMap { $0.score.asObservable() }.display(with: disposeBag)
//
//student.onNext(john)
//student.onNext(terry)
//
//john.score.accept(35)
//
//
////MARK: - StartsWith
//
////obsObj.startWith(-1).display(with: disposeBag)
//
////MARK: - Concat
//
//let concatSeq = Observable.of(11,12,13,14,15)
//
////obsObj.concat(concatSeq).display(with: disposeBag)
//
//
////MARK: - Merge
//
//let leftObj = PublishSubject<Int>()
//let rightObj = PublishSubject<Int>()
//
////Observable.merge(leftObj.asObservable(), rightObj.asObservable()).display(with: disposeBag)
//
//let group = DispatchGroup()
//
//group.enter()
//for i in 1...10 {
//    leftObj.onNext(i)
//}
//group.leave()
//
//group.enter()
//for i in 11...20 {
//    rightObj.onNext(i)
//}
//group.leave()
//
//
////MARK: - CombineLatest
//
////Observable.combineLatest(leftObj, rightObj) { el1, el2 in
////   "(DEBUG) el1 : \(el1) and el2: \(el2)"
////}.display(with: disposeBag)
//
//for _ in 1...30 {
//    let randomVal = Int.random(in: 1...30)
//    if randomVal % 2 == 0 {
//        leftObj.onNext(randomVal)
//    } else {
//        rightObj.onNext(randomVal)
//    }
//}


//MARK: - WithLatestFrom

let button = PublishSubject<Void>()
let textField = BehaviorRelay<String>(value: "")

button.withLatestFrom(textField).display(with: disposeBag)

let name = "Krishna"
for i in 0..<name.count {
    textField.accept(textField.value + name[i])
    if i % 2 == 0 {
        button.onNext(())
    }
}

//textField.accept("New TextField")

//MARK: - Reduce

//obsObj.reduce(0, accumulator: { $0 + $1 }).display(with: disposeBag)


//MARK: - Scan

//obsObj.scan(0, accumulator: +).display(with: disposeBag)
