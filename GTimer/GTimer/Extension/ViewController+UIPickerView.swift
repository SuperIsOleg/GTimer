//
//  ViewController+UIPickerView.swift
//  GTimer
//
//  Created by Home on 4.04.22.
//

import UIKit

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
     
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 4
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            
            switch component {
            case 0:
                return minIntArray.count
            case 1:
                return 1
            case 2:
                return secIntArray.count
            case 3:
                return 1
            default:
                return 0
            }
        }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(minIntArray[row])"
        case 1:
            let min = UILabel()
            min.text = "min"
            pickerView.setPickerLabels(labels: [1: min])
            return ""
        case 2:
            return "\(secIntArray[row])"
        case 3:
            let sec = UILabel()
            sec.text = "sec"
            pickerView.setPickerLabels(labels: [3: sec])
            return ""
        default:
            return "error"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            minutesNumbers = (minIntArray[row] * 60)
            print("\(durationTimer)")
        case 2:
            secondsNumbers = (secIntArray[row])
            print("\(durationTimer)")
        default:
            break
        }
        durationTimer = minutesNumbers + secondsNumbers
    }
    
    // возвращает высоту ячейки
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}

extension UIPickerView {
    
    func setPickerLabels(labels: [Int:UILabel]) { // [component number:label]
        
        let fontSize:CGFloat = 25
        let labelWidth:CGFloat = self.frame.size.width / CGFloat(self.numberOfComponents)
        let y:CGFloat = (self.frame.size.height / 2) - (fontSize / 2)

        for i in 0...self.numberOfComponents {
            
            if let label = labels[i] {
                label.frame = CGRect(x: labelWidth * CGFloat(i), y: y, width: labelWidth, height: fontSize)
                label.font = UIFont.systemFont(ofSize: fontSize, weight: .light)
                label.backgroundColor = .clear
                label.textColor = .white
                label.textAlignment = NSTextAlignment.left
                self.addSubview(label)
            }
        }
    }
}
