//
//  ViewController.swift
//  多线程
//
//  Created by myk on 2023/4/19.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        
        let btn = UIButton(frame: CGRect(x: 30, y: 100, width: 88, height: 30))
        btn.backgroundColor = .cyan
        view.addSubview(btn)
        
        btn.addTarget(self, action: #selector(pushNext), for: .touchUpInside)
    }
    
    @objc func pushNext() {
        print("\(#function)")
        let timer = Timer(timeInterval: 1, repeats: true) { _ in
                print("timer")
        }
        RunLoop.current.add(timer, forMode: .default)
    }
    
    let queue = DispatchQueue(label: "com.rw.queue", attributes: .concurrent)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let thread1 = Thread {
            for _ in 0..<3 {
                self.read(1)
            }
        }
        
        let thread2 = Thread {
            for _ in 0..<3 {
                self.read(2)
            }
        }
        
        thread1.start()
        thread2.start()
        
        print("111 == \(thread1)")
        print("222 == \(thread2)")
    }
    
    func read(_ index: Int) {
        self.queue.async {
            sleep(1)
            printXY("\(index) read in \(Thread.current)", obj: nil)
        }
    }
}


func printXY(_ any: Any, obj: Any?, line: Int? = #line) {
    let date = Date()
     let timeFormatter = DateFormatter()
     //日期显示格式，可按自己需求显示
     timeFormatter.dateFormat = "HH:mm:ss.SSS"
     let strNowTime = timeFormatter.string(from: date) as String
     print("\(strNowTime) \(type(of: obj)) \(line)： \(any)")
}
