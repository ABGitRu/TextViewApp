//
//  ViewController.swift
//  textViewApp
//
//  Created by Mac on 01.04.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = .none
        
        textView.delegate = self
        textView.font = UIFont(name: "AmericanTypewriter", size: 20)
        textView.layer.cornerRadius = 10
        textView.backgroundColor = self.view.backgroundColor
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardDidChangeFrameNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func updateTextView(notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String: AnyObject],
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0,
                                                 left: 0,
                                                 bottom: keyboardFrame.height,
                                                 right: 0)
        }
        textView.scrollRangeToVisible(textView.selectedRange)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension ViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = .white
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = self.view.backgroundColor
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        countLabel.text = "\(textView.text.count) of maximum 60"
        return textView.text.count + (text.count - range.length) <= 60
    }
}
