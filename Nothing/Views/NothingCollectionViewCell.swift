//
//  NothingCollectionViewCell.swift
//  Nothing
//
//  Created by Jose Benitez on 2/20/24.
//

import UIKit

class NothingCollectionViewCell: UICollectionViewCell {
    
    static let nothingCollectionViewCellId = "NothingCollectionViewCellReuseId"
    private var textView: NothingTextView!
    private var stackView: NothingStackView!
    var textViewIsFirstResponder: Bool {
        return textView.isFirstResponder
    }
    private var sideLength: CGFloat {
        return frame.width < frame.height ? (frame.width * 0.8) : (frame.height * 0.8)
    }
    private lazy var gestureRecognizer: UIPinchGestureRecognizer = {
        let gestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(NothingCollectionViewCell.deleteNote))
        return gestureRecognizer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textView = NothingTextView(frame: frame)
        stackView = NothingStackView(frame: frame)

        backgroundColor = .clear
        accessibilityLabel = "NothingCollectionViewCell"
        contentMode = .redraw // sets the view to be redrawn when invoking setNeedsDisplay()
        
        
        configure()
        addDeleteGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setAccessibilityLabel(with string: String) {
        accessibilityLabel = "NothingCollectionViewCell" + string
    }
    
    private func addDeleteGesture() {
        addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func deleteNote() {
        if gestureRecognizer.state == .ended {
            print("deleteNote...")
        }
    }
    
    func setNote(_ note: Note, for indexPath: IndexPath) {
        let indexPathLabel = indexPath.commaSeparatedStringRepresentation
        setAccessibilityLabel(with: indexPathLabel)
        if let noteText = String(data: note.textData ?? Data(), encoding: .utf8) {
            textView.setNoteText(with: noteText)
        }
    }
    
    private func configure() {
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalToConstant: sideLength),
            stackView.heightAnchor.constraint(equalToConstant: sideLength),
            stackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
        stackView.addArrangedSubview(textView)
        stackView.alignment = .top
        
        let textViewInsets = CGFloat(0)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -textViewInsets),
            textView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: textViewInsets),
            textView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0)
        ])
        
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = CGColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    }
}
