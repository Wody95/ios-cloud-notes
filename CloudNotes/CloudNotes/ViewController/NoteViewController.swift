//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class NoteViewController: UIViewController {
    private let tableView = UITableView()
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
    private var memoDidSaveToken: NSObjectProtocol?
    
    deinit {
        if let token = memoDidSaveToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        self.view.backgroundColor = .white
        configureNavigationItem()
        addNotificatonObserver()
    }
        
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NotesTableViewCell.self, forCellReuseIdentifier: NotesTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func configureNavigationItem() {
        self.navigationItem.title = UIConstants.strings.noteViewControllerNavigationBarTitle
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(touchUpAddButton))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func touchUpAddButton() {
        let detailNoteViewController = DetailNoteViewController()
        let navigationController = UINavigationController(rootViewController: detailNoteViewController)
        splitViewController?.showDetailViewController(navigationController, sender: nil)
    }
    
    private func addNotificatonObserver() {
        memoDidSaveToken = NotificationCenter.default.addObserver(forName: DetailNoteViewController.memoDidSave, object: nil, queue: OperationQueue.main) { [weak self] notification in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - TableView DataSource
extension NoteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NoteData.shared.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier, for: indexPath) as? NotesTableViewCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = NoteData.shared.title(index: indexPath.row)
        cell.bodyLabel.text = NoteData.shared.body(index: indexPath.row)
        cell.bodyLabel.textColor = .gray
        if let lastModifiedDate = NoteData.shared.lastModifiedDate(index: indexPath.row) {
            cell.lastModifiedDateLabel.text = dateFormatter.string(from: lastModifiedDate)
        }
        
        return cell
    }
}

// MARK: - TableView Delegate
extension NoteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailNoteViewController = DetailNoteViewController()
        detailNoteViewController.fetchedNote = NoteData.shared.note(index: indexPath.row)
        let navigationController = UINavigationController(rootViewController: detailNoteViewController)
        splitViewController?.showDetailViewController(navigationController, sender: nil)
    }
}