//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/02.
//

import UIKit

protocol MemoDetailViewDelegate {
    func configureDetailText(data: MemoData)
}

class MemoDetailViewController: UIViewController, UITextViewDelegate, MemoDetailViewDelegate {
    static let identifier: String = "DetailMemoVC"
    private var textView = UITextView()
    private var alertState: AlertState = .update

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTextViewConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        alertNotification()
    }
    
    override func viewDidLayoutSubviews() {
        textView.contentOffset = .zero
    }
    
    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(textView)
        textView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(didTapMore))
    }
    
    private func configureTextViewConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 20)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            textView.heightAnchor.constraint(equalTo: safeArea.heightAnchor),
        ])
    }

    func configureDetailText(data: MemoData) {
        self.alertState = .update
        
        guard let title = data.title else { return }
        guard let body = data.body else { return }
        
        let text = title + body
        textView.text = text
    }
    
    @objc func didTapMore() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.alertState = .delete
            if UITraitCollection.current.horizontalSizeClass == .compact {
                self.navigationController?.popViewController(animated: true)
            } else {
                
            }
            
        }
        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        
        }
        
        alert.addAction(deleteAction)
        alert.addAction(shareAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertNotification() {
        switch self.alertState {
        case .delete:
            NotificationCenter.default.post(name: NotificationNames.delete.name, object: nil)
        default:
            NotificationCenter.default.post(name: NotificationNames.update.name, object: self.textView.text)
        }
    }
}
