import UIKit
import WebKit

final class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    private var webView: WKWebView!

    private final class FileAccumulator {
        let filename: String
        let mime: String
        var data = Data()

        init(filename: String, mime: String) {
            self.filename = filename
            self.mime = mime
        }
    }

    private var pendingFiles: [String: FileAccumulator] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.09, green: 0.25, blue: 0.21, alpha: 1)

        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = false
        configuration.userContentController.add(self, name: "docukeepFile")

        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.keyboardDismissMode = .interactive
        webView.scrollView.contentInsetAdjustmentBehavior = .always
        webView.isOpaque = false
        webView.backgroundColor = .white

        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        guard let indexURL = Bundle.main.url(
            forResource: "index",
            withExtension: "html",
            subdirectory: "www"
        ) else {
            showFatalError("DocuKeep could not find its bundled app files.")
            return
        }

        let readAccessURL = indexURL.deletingLastPathComponent()
        webView.loadFileURL(indexURL, allowingReadAccessTo: readAccessURL)
    }

    deinit {
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: "docukeepFile")
    }

    private func showFatalError(_ message: String) {
        let label = UILabel()
        label.text = message
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Native file sharing bridge

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == "docukeepFile",
              let body = message.body as? [String: Any],
              let action = body["action"] as? String,
              let id = body["id"] as? String else { return }

        switch action {
        case "begin":
            let filename = sanitizeFilename(body["filename"] as? String ?? "DocuKeep_File")
            let mime = body["mime"] as? String ?? "application/octet-stream"
            pendingFiles[id] = FileAccumulator(filename: filename, mime: mime)

        case "chunk":
            guard let chunk = body["data"] as? String,
                  let decoded = Data(base64Encoded: chunk),
                  let accumulator = pendingFiles[id] else { return }
            accumulator.data.append(decoded)

        case "finish":
            guard let accumulator = pendingFiles.removeValue(forKey: id) else { return }
            shareFile(accumulator.data, filename: accumulator.filename)

        default:
            break
        }
    }

    private func sanitizeFilename(_ filename: String) -> String {
        let invalid = CharacterSet(charactersIn: "/\\:?%*|\"<>")
        return filename.components(separatedBy: invalid).joined(separator: "-")
    }

    private func shareFile(_ data: Data, filename: String) {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + "-" + filename)

        do {
            try data.write(to: url, options: .atomic)
        } catch {
            return
        }

        let activity = UIActivityViewController(activityItems: [url], applicationActivities: nil)

        if let popover = activity.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 1, height: 1)
            popover.permittedArrowDirections = []
        }

        activity.completionWithItemsHandler = { _, _, _, _ in
            try? FileManager.default.removeItem(at: url)
        }

        DispatchQueue.main.async { [weak self] in
            self?.present(activity, animated: true)
        }
    }

    // MARK: - Web navigation

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let url = navigationAction.request.url,
           let scheme = url.scheme?.lowercased(),
           (scheme == "http" || scheme == "https"),
           navigationAction.navigationType == .linkActivated {
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
            return
        }

        decisionHandler(.allow)
    }

    // MARK: - Camera permission for document capture

    @available(iOS 15.0, *)
    func webView(
        _ webView: WKWebView,
        requestMediaCapturePermissionFor origin: WKSecurityOrigin,
        initiatedByFrame frame: WKFrameInfo,
        type: WKMediaCaptureType,
        decisionHandler: @escaping (WKPermissionDecision) -> Void
    ) {
        switch type {
        case .camera:
            decisionHandler(.grant)
        default:
            decisionHandler(.deny)
        }
    }

    // MARK: - JavaScript alert / confirm / prompt support

    func webView(
        _ webView: WKWebView,
        runJavaScriptAlertPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping () -> Void
    ) {
        let alert = UIAlertController(title: "DocuKeep", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completionHandler() })
        present(alert, animated: true)
    }

    func webView(
        _ webView: WKWebView,
        runJavaScriptConfirmPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (Bool) -> Void
    ) {
        let alert = UIAlertController(title: "DocuKeep", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in completionHandler(false) })
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completionHandler(true) })
        present(alert, animated: true)
    }

    func webView(
        _ webView: WKWebView,
        runJavaScriptTextInputPanelWithPrompt prompt: String,
        defaultText: String?,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (String?) -> Void
    ) {
        let alert = UIAlertController(title: "DocuKeep", message: prompt, preferredStyle: .alert)
        alert.addTextField { field in
            field.text = defaultText
            field.isSecureTextEntry = prompt.localizedCaseInsensitiveContains("pin")
            if field.isSecureTextEntry {
                field.keyboardType = .numberPad
            }
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in completionHandler(nil) })
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler(alert.textFields?.first?.text)
        })
        present(alert, animated: true)
    }
}
