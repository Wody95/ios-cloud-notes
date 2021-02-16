//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by Yeon on 2021/02/16.
//

import UIKit

final class DetailViewController: UIViewController {
    var memoTitle: String?
    var memoBody: String?
    private var memoBodyTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextView()
    }
    
    private func setUpTextView() {
        view.addSubview(memoBodyTextView)
        guard let title = memoTitle, let body = memoBody else {
            return
        }
        let prefix = title
        let fontSize = UIFont.preferredFont(forTextStyle: .title1)
        let attributedStr = NSMutableAttributedString(string: prefix + "\n\n" + body)
        attributedStr.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String), value: fontSize, range: NSMakeRange(0, prefix.count))
        memoBodyTextView.attributedText = attributedStr
        
        NSLayoutConstraint.activate([
            memoBodyTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            memoBodyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            memoBodyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            memoBodyTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
